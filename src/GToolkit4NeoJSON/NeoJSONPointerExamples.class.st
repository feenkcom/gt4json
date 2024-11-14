Class {
	#name : #NeoJSONPointerExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONPointerExamples >> exampleBiscuits [
	<gtExample>
	| pointer biscuits |
	pointer := NeoJSONPointer new fromString: '/biscuits'.
	biscuits := self exampleJSON atPath: pointer path.
	self assert: biscuits isArray.
	self assert: biscuits size equals: 2.
	^ biscuits
]

{ #category : #accessing }
NeoJSONPointerExamples >> exampleChocoLeibniz [
	<gtExample>
	| pointer biscuit |
	pointer := NeoJSONPointer new fromString: '/biscuits/1/name'.
	biscuit := self exampleJSON atPath: pointer path.
	self assert: biscuit equals: 'Choco Leibniz'.
	^ biscuit
]

{ #category : #'as yet unclassified' }
NeoJSONPointerExamples >> exampleJSON [
	<gtExample>
	^ NeoJSONObject fromString: 
'{
  "biscuits": [
    { "name": "Digestive" },
    { "name": "Choco Leibniz" }
  ]
}'
]

{ #category : #accessing }
NeoJSONPointerExamples >> exampleRoot [
	<gtExample>
	| pointer root |
	pointer := NeoJSONPointer new.
	self assert: pointer isRoot.
	root := self exampleJSON atPath: pointer path.
	self assert: root equals: self exampleJSON.
	^ root
]
