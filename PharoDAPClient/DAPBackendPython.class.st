"
I am a backend for client connected to a Python adapter. 

I provide methods to do specific request with a Python adapter. 
"
Class {
	#name : 'DAPBackendPython',
	#superclass : 'DAPBackend',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPBackendPython >> constructorsOf: classExpr [
	"Return a collection of string corresponding to the full name of the constructors of classExpr. 
	Names are send to function breakpoint name"

	^ { '__init__' }
]

{ #category : 'accessing' }
DAPBackendPython >> equalityExpressionLeft: leftExpr right: rightExpr [

	^ leftExpr , ' == ' , rightExpr 
]

{ #category : 'accessing' }
DAPBackendPython >> expressionKey: expr instanceOf: classExpr [

	^ 'isinstance(' , expr , ',' , classExpr , ')'
]

{ #category : 'actions' }
DAPBackendPython >> hashExpressionFor: aString [

	^ 'id(' , aString , ')'
]

{ #category : 'accessing' }
DAPBackendPython >> idExpressionFor: objExpr [

	^ objExpr 
]

{ #category : 'initialization' }
DAPBackendPython >> initializeRegistry [

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP evaluate: (DAPEvaluateArguments new
						 expression:
							 '__import__("builtins").__dict__.setdefault("__dap_registry__", {})';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]

{ #category : 'accessing' }
DAPBackendPython >> instanceName [

	^ 'self'
]

{ #category : 'accessing' }
DAPBackendPython >> methodsOf: objExpr [
	"Return a collection of string corresponding to the full name of the methods of objExpr. 
	Names are send to function breakpoint name"

	| evalResp |
	evalResp := clientDAP
		            evaluate:
		            '[m for m in dir(bar) if callable(getattr(bar, m)) and not m.startswith("__")]'
		            frameId: clientDAP currentFrameId.

	^ STONJSON fromString: (evalResp at: 'result')
]

{ #category : 'accessing' }
DAPBackendPython >> readExpressionForKey: aString [
	"return ... aString is the key"

	^ '__import__("builtins").__dap_registry__.get("' , aString , '")'
]

{ #category : 'accessing' }
DAPBackendPython >> store: aString forExpression: objExpr [

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP setExpression: (DAPSetExpressionArguments new
						 expression:
							 '__import__("builtins").__dap_registry__["' , aString , '"]';
						 value: objExpr;
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
