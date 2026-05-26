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

{ #category : 'accessing' }
SindarinDAPClientForJAVA >> attachArguments [

	^ {
		  ('name' -> 'Attach to Java').
		  ('type' -> 'server').
		  ('hostName' -> host).
		  ('port' -> port).
		  ('projectName' -> 'java') } asDictionary
]

{ #category : 'initialization' }
SindarinDAPClientForJAVA >> initialize [

	super initialize.
	adapterID := 'java'.
	backend := DAPBackendJAVA new
]
