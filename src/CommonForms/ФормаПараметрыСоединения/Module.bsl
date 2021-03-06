
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыСоединения = Константы.ПараметрыСоединения.Получить().Получить();
	Если ПараметрыСоединения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСоединения);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросПриЗакрытииЗавершение", ЭтаФорма),"Данные были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена, 10, КодВозвратаДиалога.Отмена);	
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	СтрокаПараметров = РеквизитыКонстанты();
	ПараметрыСоединения = Новый Структура(СтрокаПараметров);
	ЗаполнитьЗначенияСвойств(ПараметрыСоединения, ЭтотОбъект, СтрокаПараметров);
	ЗаписатьНаСервере(ПараметрыСоединения);
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписатьНаСервере(ПараметрыСоединения)
	Константы.ПараметрыСоединения.Установить(Новый ХранилищеЗначения(ПараметрыСоединения));	
КонецПроцедуры

&НаКлиенте
Функция РеквизитыКонстанты()
	Возврат "Сервер, Порт, Пользователь, Пароль, ЭтоЗащищенноеСоединение, Токен, АдресРесурса";	
КонецФункции

&НаКлиенте
Процедура ВопросПриЗакрытииЗавершение(Ответ, ДопПараметры) Экспорт 
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Записать(Неопределено);
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



