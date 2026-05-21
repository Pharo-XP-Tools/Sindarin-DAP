Class {
	#name : 'BaselineOfPharoDAPClient',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoDAPClient',
	#package : 'BaselineOfPharoDAPClient'
}

{ #category : 'baselines' }
BaselineOfPharoDAPClient >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec baseline: 'PharoLanguageServer' with: [
					spec repository:
						'github://Pharo-XP-Tools/Pharo-LanguageServer:DAP-Tools' ].
			spec package: 'PharoDAPClient'.
			spec package: 'PharoDAPClient-Tests' ]
]
