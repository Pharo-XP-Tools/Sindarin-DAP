"
I am a Debugging Adapter Protocol to deal with JavaScript adapaters.
"
Class {
	#name : 'SindarinDAPClientForJS',
	#superclass : 'SindarinDAPClient',
	#instVars : [
		'child'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
SindarinDAPClientForJS >> attachArguments [

	^ {
		  ('name' -> 'attach pharo script.js').
		  ('type' -> 'pwa-node').
		  ('request' -> 'attach').
		  ('address' -> 'localhost').
		  ('port' -> '5005').
		  ('continueOnAttach' -> true).
		  ('skipFiles' -> { '<node_internals>/**' }) } asDictionary
]

{ #category : 'accessing' }
SindarinDAPClientForJS >> child [

	^ child
]

{ #category : 'registry' }
SindarinDAPClientForJS >> dapRegistryAt: keyAsString put: valueAsString [

	self
		stackTrace: (DAPStackTraceArguments new threadId: self mainThreadId)
		onResponse: [ :resp |
				self setExpression: (DAPSetExpressionArguments new
						 expression:
							 'globalThis.__dap_registry__["' , keyAsString , '"]';
						 value: valueAsString;
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]

{ #category : 'handle request' }
SindarinDAPClientForJS >> handleStartDebuggingRequest: aStartDebuggingRequest [

	^ DAPClientForJSStartDebug new attachOtherArguments:
		  (aStartDebuggingRequest at: 'arguments' at: 'configuration')
]

{ #category : 'initialization' }
SindarinDAPClientForJS >> initialize [

	super initialize.

	adapterID := 'node'.
	backend := DAPBackendJS new.

	requestHandlers
		at: 'startDebugging'
		put: [ :req | self handleStartDebuggingRequest: req ]
]

{ #category : 'registry' }
SindarinDAPClientForJS >> initializeDapRegistry [

	self
		stackTrace: (DAPStackTraceArguments new threadId: self mainThreadId)
		onResponse: [ :resp |
				self setExpression: (DAPSetExpressionArguments new
						 expression: 'globalThis.__dap_registry__';
						 value: '{}';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
