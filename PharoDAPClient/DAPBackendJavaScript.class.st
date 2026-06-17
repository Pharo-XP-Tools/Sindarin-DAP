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

	^ leftExpr , ' === ' , rightExpr
]

{ #category : 'accessing' }
DAPBackendJavaScript >> expressionKey: varExpr instanceOf: classExpr [

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
	"^ aString"

	^ objExpr 
]

{ #category : 'initialization' }
DAPBackendJavaScript >> initializeRegistry [

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
	"return ... aString is the key"

	^ 'globalThis.__dap_registry__[' , aString , ']'
]

{ #category : 'accessing' }
DAPBackendJavaScript >> store: aString forExpression: objExpr [

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP setExpression: (DAPSetExpressionArguments new
						 expression: 'globalThis.__dap_registry__["' , aString , '"]';
						 value: objExpr;
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
