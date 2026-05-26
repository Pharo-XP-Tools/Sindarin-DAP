"
I am a Debugging Adapter Protocol to deal with Java adapaters.
"
Class {
	#name : 'SindarinDAPClientForJAVA',
	#superclass : 'SindarinDAPClient',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'initialization' }
SindarinDAPClientForJAVA >> initialize [

	super initialize.
	adapterID := 'java'.
	backend := DAPBackendJAVA new
]

{ #category : 'accessing' }
SindarinDAPClientForJAVA >> setAttachArguments [

	^ {
		  ('name' -> 'Attach to Java').
		  ('type' -> 'server').
		  ('hostName' -> 'localhost').
		  ('port' -> 5005).
		  ('projectName' -> 'java') } asDictionary
]
