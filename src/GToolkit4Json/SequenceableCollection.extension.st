Extension { #name : #SequenceableCollection }

{ #category : #'*GToolkit4Json' }
SequenceableCollection >> asGtJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
SequenceableCollection >> asJson [
	self
		deprecated: 'Please use #asGtJson instead.'
		transformWith: '`@receiver asJson' -> '`@receiver asGtJson'.
		
	^ self asGtJson
]
