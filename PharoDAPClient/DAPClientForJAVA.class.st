Class {
	#name : 'DAPClientForJAVA',
	#superclass : 'SindarinDAPClient',
	#category : 'PharoDAPClient-Examples',
	#package : 'PharoDAPClient',
	#tag : 'Examples'
}

{ #category : 'accessing' }
DAPClientForJAVA >> attachArguments [

	^ {
		  ('name' -> 'Attach to Java').
		  ('type' -> 'server').
		  ('hostName' -> 'localhost').
		  ('port' -> 5005).
		  ('projectName' -> 'java') } asDictionary
]

{ #category : 'initialization' }
DAPClientForJAVA >> initialize [

	super initialize.
	adapterID := 'java'.
	backend := DAPBackendJAVA new
]
