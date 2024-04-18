Class {
	#name : #BaselineOfGToolkit4NeoJSON,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4NeoJSON
}

{ #category : #baseline }
BaselineOfGToolkit4NeoJSON >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:c4561bac65ff63cf5471c03d0cd6b4f9e4e852f9/repository' ].

		spec package: 'GToolkit4NeoJSON' with: [
			spec requires: #('NeoJSON') ].
	]
]
