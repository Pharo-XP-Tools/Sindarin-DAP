"
I represent a Halt on Invoke condition for the DAP protocol.

A Halt on Invoke condition is not defined by the DAP specification.

I am used when the observed object sends a message. I compare the sender of the message with the observed object to determine whether execution should halt.

"
Class {
	#name : 'DAPInvokeBreakpoint',
	#superclass : 'Object',
	#instVars : [
		'condition'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPInvokeBreakpoint >> condition [

	^ condition
]

{ #category : 'accessing' }
DAPInvokeBreakpoint >> condition: aString [

	condition := aString
]
