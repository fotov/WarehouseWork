#Область ОписаниеПеременных

&НаКлиенте
Перем НомерУстройства, СоединениеИПараметры;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "СканШтрихкода" И НомерУстройства = Источник И ВводДоступен() Тогда
		ШтрихкодПоиск = Параметр;
		ОбработатьШтрихкод(Параметр); //процедура для обработки ШК
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если КомпонентыДляСчитыванияШтрихкодов <> Неопределено Тогда
		КомпонентыДляСчитыванияШтрихкодов.Подключить(НомерУстройства);
	КонецЕсли;
	
	НастройкиСоединения = ПолучитьНастройкиСоединения();
	СоединениеИПараметры = ОбменДаннымиКлиентСервер.ПолучитьСоединениеИПараметры(НастройкиСоединения);
	
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если КомпонентыДляСчитыванияШтрихкодов <> Неопределено Тогда
		КомпонентыДляСчитыванияШтрихкодов.Отключить(НомерУстройства);
	КонецЕсли;
	СоединениеИПараметры = Неопределено;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДанныеЗаполнения") Тогда
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не переданы данные заполнения!";
		Сообщение.Сообщить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.ДанныеЗаполнения);
	
	ДополнитьДанныеЗапонения();
	
	КэшированныеЗначения = Новый Структура;
	КэшированныеЗначения.Вставить("Штрихкоды", Новый Соответствие);
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	//Отказ = НЕ КэшированныеЗначения.МожноЗакрыть;		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработатьШтрихкод(Штрихкод)
	
	ДанныеШтрихкода = ПолучитьДанныеШтрихкодаСервер(Штрихкод, КэшированныеЗначения);
	
	ТипЗнчДанныеШтрихкода = ТипЗнч(ДанныеШтрихкода);
	
	//Если ТипЗнчДанныеШтрихкода = Тип("Структура") Тогда
	//
	//	Номенклатура = ДанныеШтрихкода.Номенклатура;
	//	Упаковка = ДанныеШтрихкода.Упаковка;

	//	Если ПредыдущаяНоменклатура <> ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка")
	//		И ПредыдущаяНоменклатура <> Номенклатура Тогда
	//	
	//		КоличествоРазмещено = 0;
	//		Ячейка = ПредопределенноеЗначение("Справочник.Ячейки.ПустаяСсылка");
	//		
	//		//Ячейка = НайтиЯчейкуВРазмещении(Номенклатура);
	//		
	//	Иначе
	//		
	//		Если ЗначениеЗаполнено(Номенклатура)
	//			И ЗначениеЗаполнено(Ячейка)
	//			И ПредыдущаяНоменклатура <> ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка") Тогда
	//		
	//			ИзменитьКоличество(1);
	//			Возврат;
	//		КонецЕсли; 
	//	
	//	КонецЕсли;		
	//		
	//ИначеЕсли ТипЗнчДанныеШтрихкода = Тип("СправочникСсылка.Ячейки") Тогда
	//
	//	Ячейка = ДанныеШтрихкода;
	//	ТекущийЭтап = "ТоварыОтборПодборТовара";
	//	СканированиеЯчейкиОтбора();
	//	
	//Иначе 
	//	
	//	Сообщение = Новый СообщениеПользователю;
	//	Сообщение.Текст = "Штрихкод не найден!";
	//	Сообщение.Сообщить();
	//	
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(Номенклатура)
	//	И ЗначениеЗаполнено(Ячейка) Тогда
	//	ТекущийЭтап = "ТоварыОтборНачалоВводКоличества";
	//	СинхронизироватьДанныеСТаблицей(Истина);
	//КонецЕсли;
	//
	//ПредыдущаяНоменклатура = Номенклатура;
	//
	//УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("ОбработатьШтрихкодПриИзменении", 0.1, Истина);		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодПриИзменении()
	ОбработатьШтрихкод(ШтрихкодПоиск);	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКоличество(Разница)
	//Если КоличествоРазмещено + Разница >= 0 Тогда		
	//	КоличествоРазмещено = КоличествоРазмещено + Разница;		
	//КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеШтрихкодаСервер(Штрихкод, КэшированныеЗначения)
	
	РегистрыСведений.Сканирования.ЗарегистрироватьВводШтрихкода(Штрихкод);

	ДанныеШтрихкода = КэшированныеЗначения.Штрихкоды.Получить(Штрихкод);
	
	Если ДанныеШтрихкода = Неопределено Тогда 
		ДанныеШтрихкода = Штрихкодирование.ПолучитьДанныеПоШтрихкоду(Штрихкод, КэшированныеЗначения);
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
КонецФункции

&НаСервере
Функция ПолучитьНастройкиСоединения()
	Возврат ОбменДаннымиСервер.ПолучитьНастройкиСоединения();	
КонецФункции

&НаКлиенте
Процедура УправлениеФормой()
	
	//Элементы.ТоварыРазмещение.Видимость = КэшированныеЗначения.ПоказатьДетали;
	//	
	//Если ТекущийЭтап = КэшированныеЗначения.ТекущийЭтап Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//Если ТекущийЭтап = "ТоварыОтборНачало" Тогда
	//	СтрокаПодсказка = "Отсканируйте ячейку для отбора";
	//	Элементы.ГруппаОдиночная.Видимость = Ложь;
	//	Элементы.СброситьНоменклатуру.Видимость = Ложь;
	//ИначеЕсли ТекущийЭтап = "ТоварыОтборПодборТовара" Тогда
	//	СтрокаПодсказка = "Отсканируйте штрихкод товара";
	//	Элементы.ГруппаОдиночная.Видимость = Истина;
	//	Элементы.СброситьНоменклатуру.Видимость = Ложь;
	//	Элементы.ГруппаДеталиТоварыОтбор.ТекущаяСтраница = Элементы.ГруппаСтраницаТЧОтбор;
	//ИначеЕсли ТекущийЭтап = "ТоварыОтборНачалоВводКоличества" Тогда
	//	СтрокаПодсказка = "Укажите количество товара";
	//	Элементы.ГруппаОдиночная.Видимость = Истина;
	// 	Элементы.КоличествоРазмещено.Видимость = Истина;
	//	Элементы.СброситьНоменклатуру.Видимость = Истина;
	//	
	////ИначеЕсли ТекущийЭтап = "ОтобранныеТовары" Тогда
	////	СтрокаПодсказка = "Проверьте товары";
	////ИначеЕсли ТекущийЭтап = "ВыборТовара" Тогда
	////	СтрокаПодсказка = "Отсканируйте штрихкод товара";
	////	Элементы.ГруппаОдиночная.Видимость = Ложь;
	////	Элементы.СброситьНоменклатуру.Видимость = Ложь;
	////ИначеЕсли ТекущийЭтап = "СканЯчейки" Тогда
	////	СтрокаПодсказка = "Отсканируйте штрихкод ячейки";
	////	Элементы.ГруппаОдиночная.Видимость = Истина;
	////	Элементы.КоличествоРазмещено.Видимость = Ложь;
	////	Элементы.СброситьНоменклатуру.Видимость = Ложь;	
	////ИначеЕсли ТекущийЭтап = "ВводКоличества" Тогда
	////	СтрокаПодсказка = "Укажите количество товара";
	////	Элементы.ГруппаОдиночная.Видимость = Истина;
	//// 	Элементы.КоличествоРазмещено.Видимость = Истина;
	////	Элементы.СброситьНоменклатуру.Видимость = Истина;
	//Иначе 
	//	Сообщение = Новый СообщениеПользователю;
	//	Сообщение.Текст = "Этап """ + ТекущийЭтап + """ не обрабатывается";
	//	Сообщение.Сообщить();	
	//КонецЕсли;
	//
	//КэшированныеЗначения.ТекущийЭтап = ТекущийЭтап;
КонецПроцедуры

&НаСервере
Процедура ДополнитьДанныеЗапонения() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	10 КАК Порядок
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
		|	И ШтрихкодыНоменклатуры.Упаковка = &Упаковка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Штрихкод,
		|	20
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
		|	И ШтрихкодыНоменклатуры.Упаковка = ЗНАЧЕНИЕ(Справочник.Упаковки.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
					
КонецПроцедуры

#КонецОбласти
