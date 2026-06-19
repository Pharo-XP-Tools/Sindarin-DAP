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
	"Return an equality expression between two expressions."

	^ leftExpr , ' == ' , rightExpr
]

{ #category : 'accessing' }
DAPBackendPython >> expressionKey: expr instanceOf: classExpr [
	"Creates an expression that checks whether the given variable
    expression is an instance of the specified class expression."

	^ 'isinstance(' , expr , ',' , classExpr , ')'
]

{ #category : 'actions' }
DAPBackendPython >> hashExpressionFor: aString [

	"Return an expression that when evaluated by the python debug adapter computes the identity hash of aString."

	^ 'id(' , aString , ')'
]

{ #category : 'initialization' }
DAPBackendPython >> initializeRegistry [
	"Initializes the registry used to store data in the debuggee program."

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
	"Creates an expression that reads the value associated with the given key from the registry."

	^ '__import__("builtins").__dap_registry__.get("' , aString , '")'
]

{ #category : 'accessing' }
DAPBackendPython >> store: aString forExpression: objExpr [
	"Stores the given expression in the registry under the specified key."

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
