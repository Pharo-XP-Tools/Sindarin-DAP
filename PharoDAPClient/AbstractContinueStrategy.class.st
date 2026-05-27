"
I am a Strategy (desing pattern) for the ""Continue"" action. 

My subclasses implement various algorithms to do a ""Continue"" action.
"
Class {
	#name : 'AbstractContinueStrategy',
	#superclass : 'Object',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'requests' }
AbstractContinueStrategy >> continue: sindarinDAPClient [

	self subclassResponsibility
]
