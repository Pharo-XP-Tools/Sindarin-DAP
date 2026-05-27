"
I am the common strategy to do a ""Continue"" action which simply send the ""Continue"" request to the adapter.
"
Class {
	#name : 'DebugContinueStrategy',
	#superclass : 'AbstractContinueStrategy',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'requests' }
DebugContinueStrategy >> continue: sindarinDAPClient [

	sindarinDAPClient continue:
		(DAPContinueArguments new threadId: sindarinDAPClient mainThreadId)
]
