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
			baseline: 'GToolkit4NeoJSON' with: [
				spec repository: 'github://feenkcom/gt4json:v0.7.375/src' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.9.71/src' ].
		spec
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.9.188/src' ].
		spec
			baseline: 'JSONParser' with: [
				spec repository: 'github://j-brant/SmaCC:ef9cc90dddf7a8bcbba06f01d8ea4347f8fd595f/src' ].
		spec
			baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.9.373/src' ].

		spec package: 'GToolkit4Json' with: [
			spec requires: #(#GToolkit4NeoJSON #GToolkitBasicUtility #Brick #JSONParser #GToolkitInspector) ].
	]
]
