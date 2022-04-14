Extension { #name : #StandardOrderedDictionary }

{ #category : #'*GToolkit4Json' }
StandardOrderedDictionary >> asJson [

	^ GtJson forJsonObject: self
]
