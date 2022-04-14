Extension { #name : #OrderedDictionary }

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> asJson [

	^ GtJson forJsonObject: self
]
