Extension { #name : 'BlockClosure' }

{ #category : '*PharoDAPClient' }
BlockClosure >> stepUntilOn: aSindarinDAPClient [

	aSindarinDAPClient stepUntilBlock: self
]

{ #category : '*PharoDAPClient' }
BlockClosure >> stepUntilOn: aSindarinDAPClient do: aBlock [

	aSindarinDAPClient stepUntilBlock: self do: aBlock 
]
