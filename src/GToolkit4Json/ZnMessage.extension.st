Extension { #name : #ZnMessage }

{ #category : #'*GToolkit4Json' }
ZnMessage >> asGtJson [
	^ GtJson forJsonString: self contents
]

{ #category : #'*GToolkit4Json' }
ZnMessage >> asJson [
	self
		deprecated: 'Please use #asGtJson instead.'
		transformWith: '`@receiver asJson' -> '`@receiver asGtJson'.
		
	^ self asGtJson
]
