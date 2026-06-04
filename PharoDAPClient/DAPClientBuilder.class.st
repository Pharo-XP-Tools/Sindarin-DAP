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
		'attachArguments',
		'backend',
		'semaphore'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'instance creation' }
DAPClientBuilder class >> newSindarinClient [

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
DAPClientBuilder >> attachArguments: anAttachArguments [

	attachArguments := anAttachArguments
]

{ #category : 'private' }
DAPClientBuilder >> attachClient [

	client attach: attachArguments
]

{ #category : 'accessing' }
DAPClientBuilder >> backend: aDAPBackend [

	backend := aDAPBackend
]

{ #category : 'accessing' }
DAPClientBuilder >> breakpoint: scriptPath line: anNumber [

	breakpoints at: scriptPath ifAbsentPut: [ OrderedCollection new ].

	(breakpoints at: scriptPath) add:
		(DAPSourceBreakpoint new line: anNumber)
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
DAPClientBuilder >> configurationDone [

	client configurationDone
]

{ #category : 'private' }
DAPClientBuilder >> connectClient [

	client connectTo: host port: port.
	client startListening.
	client initialize: self initializeArguments.
]

{ #category : 'private' }
DAPClientBuilder >> connectClient: aBlock [

	client connectTo: host port: port.
	client startListening.
	client initialize: (self initializeArguments) onResponse: aBlock.
]

{ #category : 'accessing' }
DAPClientBuilder >> functionBreakpoint: functionName [

	functionBreakpoints add:
		(DAPFunctionBreakpoint new name: functionName)
]

{ #category : 'accessing' }
DAPClientBuilder >> functionBreakpoint: functionName condition: aString [

	functionBreakpoints add: (DAPFunctionBreakpoint new
			 name: functionName;
			 condition: aString)
]

{ #category : 'accessing' }
DAPClientBuilder >> handleStartDebuggingRequest [

	client requestHandlersAt: 'startDebugging' put: [ :req |
			| secondClient |
			self client: client class new.
			attachArguments addAll: (req at: 'arguments' at: 'configuration').
			secondClient := self startClientSession. 
			client := secondClient.
			semaphore signal.
		]
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
	semaphore := Semaphore new
]

{ #category : 'private' }
DAPClientBuilder >> initializeArguments [

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
		  supportsStartDebuggingRequest: false;
		  locale: 'en'
]

{ #category : 'private' }
DAPClientBuilder >> launchClient [

	client launch: attachArguments
]

{ #category : 'accessing' }
DAPClientBuilder >> port: anNumber [

	port := anNumber
]

{ #category : 'private' }
DAPClientBuilder >> setBreakpoints [

	breakpoints keysAndValuesDo: [ :scriptPath :sourceBreakpoints |
			| args |
			args := DAPSetBreakpointsArguments new
				        source: (DAPSource new path: scriptPath);
				        breakpoints: sourceBreakpoints asArray.

			client setBreakpoints: args ]
]

{ #category : 'private' }
DAPClientBuilder >> setFunctionBreakpoints [

	| args |
	args := DAPSetFunctionBreakpointsArguments new breakpoints:
		        functionBreakpoints asArray.

	client setFunctionBreakpoints: args
]

{ #category : 'api' }
DAPClientBuilder >> startClientSession [

	port ifNil: [ ^ self ].
	adapterID ifNil: [ ^ self ].
	attachArguments ifNil: [ ^ self ].


	client onEvent: 'initialized' do: [ :event |
			self setBreakpoints.
			self setFunctionBreakpoints.
			self configurationDone ].

	self connectClient: [ :resp | self launchClient ].

	(client respondsTo: #backend:) ifTrue: [ client backend: backend ].
	
	semaphore waitTimeoutSeconds: 2.

	^ client
]
