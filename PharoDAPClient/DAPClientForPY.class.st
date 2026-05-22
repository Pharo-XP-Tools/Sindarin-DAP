Class {
	#name : 'DAPClientForPY',
	#superclass : 'SindarinDAPClient',
	#category : 'PharoDAPClient-Examples',
	#package : 'PharoDAPClient',
	#tag : 'Examples'
}

{ #category : 'initialization' }
DAPClientForPY >> attachArguments [

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

{ #category : 'initialization' }
DAPClientForPY >> initialize [

	super initialize.

	adapterID := 'python'.
	backend := DAPBackendPY new
]

{ #category : 'stack access' }
DAPClientForPY >> variablesForObject: aVariableName inStackFrame: frameId [

	| specialVariablesReference |
	specialVariablesReference := (super
		                              variablesForObject: aVariableName
		                              inStackFrame: frameId) first at:
		                             'variablesReference'.
	^ self variablesForReference: specialVariablesReference
]
