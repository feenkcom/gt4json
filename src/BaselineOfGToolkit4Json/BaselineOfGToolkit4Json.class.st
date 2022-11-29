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
					with: [ spec repository: 'github://svenvc/NeoJSON:v17/repository' ];
				baseline: 'OrderPreservingDictionary'
					with: [ spec
							repository: 'github://pharo-contributions/OrderPreservingDictionary:bee45d74ab513cf6230bdda2dcbaecd46905f7e6/src' ].

			spec package: 'GToolkit4Json' with: [ spec requires: #('NeoJSON' 'OrderPreservingDictionary') ] ]
]
