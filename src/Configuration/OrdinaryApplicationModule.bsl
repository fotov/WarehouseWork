// ПодключаемоеОборудование
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
// Конец ПодключаемоеОборудование

Процедура ПриНачалеРаботыСистемы()

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование

КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
 
 // ПодключаемоеОборудование
 МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
 // Конец ПодключаемоеОборудование
 
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	// Передать на обработку данные.
	МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия);
	
КонецПроцедуры
