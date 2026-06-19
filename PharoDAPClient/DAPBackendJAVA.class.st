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
	"Return an equality expression between two expressions."

	^ leftExpr , ' == ' , rightExpr
]

{ #category : 'accessing' }
DAPBackendJava >> expressionKey: varExpr instanceOf: classExpr [
	"Creates an expression that checks whether the given variable
    expression is an instance of the specified class expression."

	^ varExpr , ' instanceof ' , classExpr
]

{ #category : 'actions' }
DAPBackendJava >> hashExpressionFor: aString [

	"Return an expression that when evaluated by the java debug adapter computes the identity hash of aString."

	^ 'System.identityHashCode(' , aString , ')'
]

{ #category : 'accessing' }
DAPBackendJava >> idExpressionFor: expr [
	"Creates an expression that retrieves the identifier of the given object expression."

	^ expr
]

{ #category : 'initialization' }
DAPBackendJava >> initializeRegistry [
	"Initializes the registry used to store data in the debuggee program."

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
	"Creates an expression that reads the value associated with the given key from the registry."

	^ '((java.util.Map<String,Object>)System.getProperties().get("__dap_registry__")).get("'
	  , aString , '")'
]

{ #category : 'accessing' }
DAPBackendJava >> store: aString forExpression: objExpr [
	"Stores the given expression in the registry under the specified key."

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
