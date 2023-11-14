Class {
	#name : #BaselineOfGToolkit4Json,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Json
}

{ #category : #baseline }
BaselineOfGToolkit4Json >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'GToolkit4NeoJSON'
				with: [ spec repository: 'github://feenkcom/gt4json:main/src' ].

			spec
				baseline: 'GToolkitBasicUtility'
				with: [ spec repository: 'github://feenkcom/gtoolkit-utility:main/src' ].

			spec
				baseline: 'Brick'
				with: [ spec repository: 'github://feenkcom/Brick:main/src' ].
				
			spec
				baseline: 'JSONParser'
				with: [ spec repository: 'github://j-brant/SmaCC' ].

			spec
				baseline: 'GToolkitInspector'
				with: [ spec repository: 'github://feenkcom/gtoolkit-inspector:main/src' ].

			spec
				package: 'GToolkit4Json'
				with: [ spec
						requires: #('GToolkit4NeoJSON' 'GToolkitBasicUtility' 'Brick' 'JSONParser' 'GToolkitInspector') ] ]
]
