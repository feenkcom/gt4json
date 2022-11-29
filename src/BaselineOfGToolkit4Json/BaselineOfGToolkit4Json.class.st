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
				baseline: 'NeoJSON'
				with: [ spec repository: 'github://svenvc/NeoJSON:v17/repository' ].

			spec
				baseline: 'GToolkitBasicUtility'
				with: [ spec repository: 'github://feenkcom/gtoolkit-utility:main/src' ].

			spec
				baseline: 'Brick'
				with: [ spec repository: 'github://feenkcom/Brick:main/src' ].

			spec
				baseline: 'SmaCC'
				with: [ spec repository: 'github://j-brant/SmaCC:Pharo10/src' ].

			spec
				baseline: 'GToolkitInspector'
				with: [ spec repository: 'github://feenkcom/gtoolkit-inspector:main/src' ].

			spec
				package: 'GToolkit4Json'
				with: [ spec
						requires: #('NeoJSON' 'GToolkitBasicUtility' 'Brick' 'SmaCC' 'GToolkitInspector') ] ]
]
