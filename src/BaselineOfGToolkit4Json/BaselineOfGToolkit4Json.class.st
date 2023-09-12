Class {
	#name : #BaselineOfGToolkit4Json,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Json
}

{ #category : #baseline }
BaselineOfGToolkit4Json >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:b05162a6e420b501a87c6fc9503745b69d51237a/repository' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.223/src' ].
		spec
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.8.1028/src' ].
		spec
			baseline: 'JSONParser' with: [
				spec repository: 'github://j-brant/SmaCC:v3.0.19' ].
		spec
			baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.8.1796/src' ].

		spec package: 'GToolkit4Json' with: [
			spec requires: #('NeoJSON' 'GToolkitBasicUtility' 'Brick' 'JSONParser' 'GToolkitInspector') ].
	]
]
