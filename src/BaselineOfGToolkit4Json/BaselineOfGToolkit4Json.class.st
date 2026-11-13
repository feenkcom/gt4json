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
				spec repository: 'github://feenkcom/gt4json:v0.7.357/src' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.9.65/src' ].
		spec
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.9.173/src' ].
		spec
			baseline: 'JSONParser' with: [
				spec repository: 'github://j-brant/SmaCC:8c1dd09d00f6cbdd0bc37e3722291056c851fabf/src' ].
		spec
			baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.9.355/src' ].

		spec package: 'GToolkit4Json' with: [
			spec requires: #(#GToolkit4NeoJSON #GToolkitBasicUtility #Brick #JSONParser #GToolkitInspector) ].
	]
]
