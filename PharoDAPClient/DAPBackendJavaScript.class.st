"
I am a backend for client connected to a JavaScript adapter.

I provide methods to do specific request with a JavaScript adapter.
"
Class {
	#name : 'DAPBackendJavaScript',
	#superclass : 'DAPBackend',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPBackendJavaScript >> constructorsOf: classExpr [
	"Return a collection of string corresponding to the full name of the constructors of classExpr. 
	Names are send to function breakpoint name"

	^ { 'constructor' }
]

{ #category : 'accessing' }
DAPBackendJavaScript >> equalityExpressionLeft: leftExpr right: rightExpr [
	"Return an equality expression between two expressions."

	^ leftExpr , ' === ' , rightExpr
]

{ #category : 'accessing' }
DAPBackendJavaScript >> expressionKey: varExpr instanceOf: classExpr [
	"Creates an expression that checks whether the given variable
    expression is an instance of the specified class expression."

	^ varExpr , ' instanceof ' , classExpr
]

{ #category : 'actions' }
DAPBackendJavaScript >> hashExpressionFor: aString [
	"Return an expression that when evaluated by the debug adapter computes the identity hash of aString.
	Not supported for JS"

	^ ''
]

{ #category : 'accessing' }
DAPBackendJavaScript >> idExpressionFor: objExpr [
	"Creates an expression that retrieves the identifier of the given object expression."

	^ objExpr
]

{ #category : 'initialization' }
DAPBackendJavaScript >> initializeRegistry [
	"Initializes the registry used to store data in the debuggee program."

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP setExpression: (DAPSetExpressionArguments new
						 expression: 'globalThis.__dap_registry__';
						 value: '{}';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]

{ #category : 'accessing' }
DAPBackendJavaScript >> instanceName [
	"return this or self"

	^ 'this'
]

{ #category : 'accessing' }
DAPBackendJavaScript >> methodsOf: objExpr [
	"Return a collection of string corresponding to the full name of the methods of objExpr. 
	Names are send to function breakpoint name"

	^ {  }
]

{ #category : 'accessing' }
DAPBackendJavaScript >> readExpressionForKey: aString [
	"Creates an expression that reads the value associated with the given key from the registry."

	^ 'globalThis.__dap_registry__[' , aString , ']'
]

{ #category : 'accessing' }
DAPBackendJavaScript >> store: aString forExpression: objExpr [
	"Stores the given expression in the registry under the specified key."

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP setExpression: (DAPSetExpressionArguments new
						 expression: 'globalThis.__dap_registry__["' , aString , '"]';
						 value: objExpr;
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
