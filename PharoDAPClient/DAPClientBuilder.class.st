"
I am a builder for DAPClient and SindarinDAPClient objects. 

In order to build such an object, you can use these methods: 

- `port:` to specify the port 
- `host:` to specify the host (default is 'localhost')
- `client:` which can be an instance of DAPClient or SindarinDAPClient (default is 'DAPClient') 
- `attachArguments: aDictionary` to specify the attachArguments 
- `breakpoint: aFileReference line: anInteger` to setup a breakpoint at session initialization
- `functionBreakpoint:` to setup a functionBreakpoint at session initialization
"
Class {
	#name : 'DAPClientBuilder',
	#superclass : 'Object',
	#instVars : [
		'client',
		'host',
		'port',
		'adapterID',
		'breakpoints',
		'functionBreakpoints',
		'backend',
		'semaphore',
		'startDebuggingRequest',
		'arguments'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'instance creation' }
DAPClientBuilder class >> newSindarinClient [
	"Entry point to build a SindarinDAPClient"

	| builder |
	builder := self new.
	builder client: SindarinDAPClient new.

	^ builder
]

{ #category : 'accessing' }
DAPClientBuilder >> adapterID: aString [

	adapterID := aString
]

{ #category : 'accessing' }
DAPClientBuilder >> arguments: aDictionaryOfArguments [

	arguments := aDictionaryOfArguments
]

{ #category : 'accessing' }
DAPClientBuilder >> backend: aDAPBackend [

	backend := aDAPBackend
]

{ #category : 'accessing' }
DAPClientBuilder >> breakpoint: aFileReference line: anInteger [
	"Registers a breakpoint at the file in aFileReference and line anInteger"

	breakpoints at: aFileReference ifAbsentPut: [ OrderedCollection new ].

	(breakpoints at: aFileReference) add:
		(DAPSourceBreakpoint new line: anInteger)
]

{ #category : 'accessing' }
DAPClientBuilder >> client [

	client
]

{ #category : 'accessing' }
DAPClientBuilder >> client: aDAPClient [

	client := aDAPClient
]

{ #category : 'private' }
DAPClientBuilder >> connectClient: aBlock [
	"Connects the client to the adapter, sends the initialize request, wait for response and then execute aBlock"

	client connectTo: host port: port.
	client startListening.
	client initialize: self initializeArguments onResponse: aBlock
]

{ #category : 'accessing' }
DAPClientBuilder >> functionBreakpoint: aFunctionName [
	"Registers a function breakpoint for the function named aFunctionName"

	functionBreakpoints add:
		(DAPFunctionBreakpoint new name: aFunctionName)
]

{ #category : 'accessing' }
DAPClientBuilder >> functionBreakpoint: functionName condition: aString [
	"Registers a function breakpoint for the function named aFunctionName with the condition aString"

	functionBreakpoints add: (DAPFunctionBreakpoint new
			 name: functionName;
			 condition: aString)
]

{ #category : 'private' }
DAPClientBuilder >> handleStartDebuggingRequest [
	"Handles case when adapter is sending a startDebugging request"

	client requestHandlersAt: 'startDebugging' put: [ :req |
			| initialClient newClient |
			initialClient := client.
			self client: client class new.
			arguments addAll: (req at: 'arguments' at: 'configuration').
			startDebuggingRequest := false.
			newClient := self startClientSession.
			client := newClient.
			semaphore signal.
			initialClient closeConnection ]
]

{ #category : 'accessing' }
DAPClientBuilder >> host: aString [

	host := aString
]

{ #category : 'initialization' }
DAPClientBuilder >> initialize [

	super initialize.
	host := 'localhost'.
	client := DAPClient new.
	breakpoints := Dictionary new.
	functionBreakpoints := OrderedCollection new.
	startDebuggingRequest := false.
	semaphore := Semaphore new
]

{ #category : 'private' }
DAPClientBuilder >> initializeArguments [
	"Returns the initialize request according to DAP protocol"

	^ DAPInitializeRequestArguments new
		  clientID: 'my-dap-client';
		  clientName: 'Pharo dap client';
		  adapterID: adapterID;
		  pathFormat: 'path';
		  linesStartAt1: true;
		  columnsStartAt1: true;
		  supportsProgressReporting: true;
		  supportsMemoryReferences: true;
		  supportsInvalidatedEvent: true;
		  supportsRunInTerminalRequest: true;
		  supportsVariableType: true;
		  supportsArgsCanBeInterpretedByShell: true;
		  supportsMemoryEvent: true;
		  supportsStartDebuggingRequest: startDebuggingRequest;
		  locale: 'en'
]

{ #category : 'private' }
DAPClientBuilder >> launchClient [
	"Sends the launch request according to DAP protocol to the adapter"

	client launch: arguments
]

{ #category : 'accessing' }
DAPClientBuilder >> port: anNumber [

	port := anNumber
]

{ #category : 'private' }
DAPClientBuilder >> setBreakpoints [
	"Installs all registered breakpoints"

	breakpoints keysAndValuesDo: [ :scriptPath :sourceBreakpoints |
			| args |
			args := DAPSetBreakpointsArguments new
				        source: (DAPSource new path: scriptPath);
				        breakpoints: sourceBreakpoints asArray.

			client setBreakpoints: args ]
]

{ #category : 'private' }
DAPClientBuilder >> setFunctionBreakpoints [
	"Installs all registered function breakpoints"

	| args |
	args := DAPSetFunctionBreakpointsArguments new breakpoints:
		        functionBreakpoints asArray.

	client setFunctionBreakpoints: args
]

{ #category : 'api' }
DAPClientBuilder >> startClientSession [
	"Start the DAPClient session and returns it ready to use"

	startDebuggingRequest ifTrue: [ self handleStartDebuggingRequest ].

	port ifNil: [ ^ self ].
	adapterID ifNil: [ ^ self ].
	arguments ifNil: [ ^ self ].

	client onEvent: 'initialized' do: [ :event |
			self setBreakpoints.
			self setFunctionBreakpoints.
			client configurationDone ].

	self connectClient: [ :resp | self launchClient ].

	(client respondsTo: #backend:) ifTrue: [ client backend: backend ].

	startDebuggingRequest ifTrue: [
			semaphore
				waitTimeoutSeconds: 1
				onCompletion: [ ]
				onTimeout: [ ^ Error new signal: 'Request not received' ] ].

	^ client
]

{ #category : 'accessing' }
DAPClientBuilder >> startDebuggingRequest: aBoolean [

	startDebuggingRequest := aBoolean
]
