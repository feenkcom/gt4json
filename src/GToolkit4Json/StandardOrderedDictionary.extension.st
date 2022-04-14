Extension { #name : #StandardOrderedDictionary }

{ #category : #'*GToolkit4Json' }
StandardOrderedDictionary >> asJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
StandardOrderedDictionary >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeMap: self
]
