Class {
	#name : 'DAPClientForJSStartDebug',
	#superclass : 'DAPClientForJS',
	#instVars : [
		'attachOtherArguments'
	],
	#category : 'PharoDAPClient-Examples',
	#package : 'PharoDAPClient',
	#tag : 'Examples'
}

{ #category : 'accessing' }
DAPClientForJSStartDebug >> attachOtherArguments [

	^ attachOtherArguments
]

{ #category : 'accessing' }
DAPClientForJSStartDebug >> attachOtherArguments: anAttachArguments [

	 attachArguments := anAttachArguments addAll: attachOtherArguments. 
]
