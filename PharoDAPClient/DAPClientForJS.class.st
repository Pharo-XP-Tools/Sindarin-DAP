Class {
	#name : 'DAPClientForJS',
	#superclass : 'SindarinDAPClient',
	#instVars : [
		'child'
	],
	#category : 'PharoDAPClient-Examples',
	#package : 'PharoDAPClient',
	#tag : 'Examples'
}

{ #category : 'accessing' }
DAPClientForJS >> attachArguments [

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
DAPClientForJS >> child [

	^ child
]

{ #category : 'registry' }
DAPClientForJS >> dapRegistryAt: keyAsString put: valueAsString [

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
DAPClientForJS >> handleStartDebuggingRequest: aStartDebuggingRequest [

	^ DAPClientForJSStartDebug new attachOtherArguments:
		  (aStartDebuggingRequest at: 'arguments' at: 'configuration')
]

{ #category : 'initialization' }
DAPClientForJS >> initialize [

	super initialize.

	adapterID := 'node'.
	backend := DAPBackendJS new.

	requestHandlers
		at: 'startDebugging'
		put: [ :req | self handleStartDebuggingRequest: req ]
]

{ #category : 'registry' }
DAPClientForJS >> initializeDapRegistry [

	self
		stackTrace: (DAPStackTraceArguments new threadId: self mainThreadId)
		onResponse: [ :resp |
				self setExpression: (DAPSetExpressionArguments new
						 expression: 'globalThis.__dap_registry__';
						 value: '{}';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
