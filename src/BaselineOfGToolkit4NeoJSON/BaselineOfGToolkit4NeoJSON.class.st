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
				spec repository: 'github://svenvc/NeoJSON:19bb4ca4c6f68defee93bea24efddee8a8122ab4/repository' ].

		spec package: 'GToolkit4NeoJSON' with: [
			spec requires: #('NeoJSON') ].
	]
]
