"
I am a Debugging Adapter Protocol to deal with Python adapaters.
"
Class {
	#name : 'SindarinDAPClientForPython',
	#superclass : 'SindarinDAPClient',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'initialization' }
SindarinDAPClientForPython >> initialize [

	super initialize.

	adapterID := 'python'.
	backend := DAPBackendPY new
]

{ #category : 'initialization' }
SindarinDAPClientForPython >> setAttachArguments [

	^ {
		  ('name' -> 'Attach to Python').
		  ('type' -> 'python').
		  ('connect' -> {
			   ('host' -> 'localhost').
			   ('port' -> 5678) } asDictionary).
		  ('redirectOutput' -> true).
		  ('showReturnValue' -> true).
		  ('justMyCode' -> false) } asDictionary
]

{ #category : 'stack access' }
SindarinDAPClientForPython >> variablesForObject: aVariableName inStackFrame: frameId [

	| specialVariablesReference |
	specialVariablesReference := (super
		                              variablesForObject: aVariableName
		                              inStackFrame: frameId) first at:
		                             'variablesReference'.
	^ self variablesForReference: specialVariablesReference
]
