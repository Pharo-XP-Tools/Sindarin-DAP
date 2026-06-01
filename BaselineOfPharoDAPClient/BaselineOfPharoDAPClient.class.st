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
			spec
				baseline: 'PharoLanguageServer' with: [
						spec repository:
								'github://Pharo-XP-Tools/Pharo-LanguageServer:DAP-Tools' ];
				baseline: 'Mocketry'
				with: [ spec repository: 'github://dionisiydk/Mocketry:master' ].
			spec package: 'PharoDAPClient'.
			spec package: 'PharoDAPClient-Tests' ]
]
