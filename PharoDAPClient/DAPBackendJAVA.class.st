"
I am a backend for client connected to a Java adapter.

I provide methods to do specific request with a Java adapter.
"
Class {
	#name : 'DAPBackendJava',
	#superclass : 'DAPBackend',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPBackendJava >> constructorsOf: classExpr [
	"Return a collection of string corresponding to the full name of the constructors of classExpr. 
	Names are send to function breakpoint name"

	self flag: 'hard coded'.

	^ { ('example.' , classExpr , '#<init>') }
]

{ #category : 'accessing' }
DAPBackendJava >> equalityExpressionLeft: leftExpr right: rightExpr [

	^ leftExpr , ' == ' , rightExpr
]

{ #category : 'accessing' }
DAPBackendJava >> expressionKey: varExpr instanceOf: classExpr [

	^ varExpr , ' instanceof ' , classExpr
]

{ #category : 'actions' }
DAPBackendJava >> hashExpressionFor: aString [

	"Return an expression that when evaluated by the java debug adapter computes the identity hash of aString."

	^ 'System.identityHashCode(' , aString , ')'
]

{ #category : 'accessing' }
DAPBackendJava >> idExpressionFor: expr [

	^ expr
]

{ #category : 'initialization' }
DAPBackendJava >> initializeRegistry [

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP evaluate: (DAPEvaluateArguments new
						 expression:
							 'System.getProperties().putIfAbsent("__dap_registry__", new java.util.HashMap<String,Object>())';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]

{ #category : 'accessing' }
DAPBackendJava >> instanceName [

	^ 'this'
]

{ #category : 'accessing' }
DAPBackendJava >> methodsOf: objExpr [
	"Return a collection of string corresponding to the full name of the methods of objExpr. 
	Names are send to function breakpoint name"

	| evalResp |
	evalResp := clientDAP
		            evaluate:
			            'java.util.Arrays.stream(' , objExpr
			            , '.getClass().getMethods())
    .map(m -> ' , objExpr
			            , '.getClass().getPackage().getName() + "." + '
			            , objExpr
			            , '.getClass().getSimpleName() + "#" + m.getName())
    .toList()'
		            frameId: clientDAP currentFrameId.

	^ (clientDAP variablesForReference:
		   (evalResp at: 'variablesReference')) collect: [ :dapVar |
		  dapVar at: 'value' ]
]

{ #category : 'accessing' }
DAPBackendJava >> readExpressionForKey: aString [
	"return ... aString is the key"

	^ '((java.util.Map<String,Object>)System.getProperties().get("__dap_registry__")).get("'
	  , aString , '")'
]

{ #category : 'accessing' }
DAPBackendJava >> store: aString forExpression: objExpr [

	clientDAP
		stackTrace:
		(DAPStackTraceArguments new threadId: clientDAP mainThreadId)
		onResponse: [ :resp |
				clientDAP evaluate: (DAPEvaluateArguments new
						 expression:
							 '((java.util.Map<String, Object>)System.getProperties().get("__dap_registry__")).put("'
							 , aString , '", ' , objExpr , ')';
						 frameId: (((resp at: 'body') at: 'stackFrames') first at: 'id')) ]
]
