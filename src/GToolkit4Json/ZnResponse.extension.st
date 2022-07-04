Extension { #name : #ZnResponse }

{ #category : #'*GToolkit4Json' }
ZnResponse >> asJson [
	^ GtJson forJsonString: self contents
]
