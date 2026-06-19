"
I am an abstract class allowing to link a DAPClient with a specific langage and then have requests in addition of the native DAP one's.

A DAPClient must have a DAPBackend to interact with an adapter.
"
Class {
	#name : 'DAPBackend',
	#superclass : 'Object',
	#instVars : [
		'clientDAP'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPBackend >> buildInstanceCondition: objExpr [
	"Builds an equality condition that compares the current instance
    identifier with the identifier of the given object expression.

    The object expression is first stored in the registry using a
    generated key. The corresponding read expression is then created
    and compared to the current instance identifier."

	| key leftExpr rightExpr |
	key := self generateKey.
	self store: key forExpression: objExpr.

	leftExpr := self instanceName.
	rightExpr := self readExpressionForKey: key.

	^ self equalityExpressionLeft: leftExpr right: rightExpr
]

{ #category : 'accessing' }
DAPBackend >> clientDAP: aDAPClient [

	clientDAP := aDAPClient
]

{ #category : 'accessing' }
DAPBackend >> constructorsOf: classExpr [
	"Return a collection of string corresponding to the full name of the constructors of classExpr. 
	Names are send to function breakpoint name"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> equalityExpressionLeft: leftExpr right: rightExpr [
	"Return an equality expression between two expressions."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> expressionKey: varExpr instanceOf: classExpr [
	"Creates an expression that checks whether the given variable
    expression is an instance of the specified class expression."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> generateKey [
	"Generates a unique key used to store and retrieve expressions
    from the registry."

	^ 'instance_' , UUID new asString
]

{ #category : 'actions' }
DAPBackend >> hashExpressionFor: aString [
	"Return an expression that when evaluated by the debug adapter computes the hash of aString."

	^ self subclassResponsibility
]

{ #category : 'initialization' }
DAPBackend >> initializeRegistry [
	"Initializes the registry used to store data in the debuggee program."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> instanceName [
	"return this or self"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> methodsOf: objExpr [
	"Return a collection of string corresponding to the full name of the methods of objExpr. 
	Names are send to function breakpoint name"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> readExpressionForKey: aString [
	"Creates an expression that reads the value associated with the given key from the registry."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DAPBackend >> store: aString forExpression: objExpr [
	"Stores the given expression in the registry under the specified key."

	^ self subclassResponsibility
]
