Extension { #name : 'ByteString' }

{ #category : '*PharoDAPClient' }
ByteString >> stepUntilOn: aSindarinDAPClient [

	aSindarinDAPClient stepUntilString: self
]

{ #category : '*PharoDAPClient' }
ByteString >> stepUntilOn: aSindarinDAPClient do: aBlock [

	aSindarinDAPClient stepUntilString: self do: aBlock 
]
