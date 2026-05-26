Class {
	#name : 'DAPClientForJSStartDebug',
	#superclass : 'SindarinDAPClientForJS',
	#instVars : [
		'attachOtherArguments'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'accessing' }
DAPClientForJSStartDebug >> attachOtherArguments [

	^ attachOtherArguments
]

{ #category : 'accessing' }
DAPClientForJSStartDebug >> attachOtherArguments: anAttachArguments [

	 attachArguments := anAttachArguments addAll: attachOtherArguments. 
]
