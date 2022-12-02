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
				spec repository: 'github://svenvc/NeoJSON:v17/repository' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.159/src' ].
		spec
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.8.788/src' ].
		spec
			baseline: 'SmaCC' with: [
				spec repository: 'github://j-brant/SmaCC:3a1c5948755d13868864f545c235bebfeb994931/src' ].
		spec
			baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.8.1312/src' ].

		spec package: 'GToolkit4Json' with: [
			spec requires: #('NeoJSON' 'GToolkitBasicUtility' 'Brick' 'SmaCC' 'GToolkitInspector') ].
	]
]
