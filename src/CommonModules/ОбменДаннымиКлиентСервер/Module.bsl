#Область ПрограммныйИнтерфейс

Функция ПолучитьСоединениеИПараметры(ПараметрыСоединения) Экспорт
	
	СтруктураСоединения = Новый Структура("Соединение, Параметры");
	
	СтруктураСоединения.Соединение = СоздатьСоединение(ПараметрыСоединения);
	СтруктураСоединения.Параметры = Новый Структура("АдресРесурса, Токен");
	ЗаполнитьЗначенияСвойств(СтруктураСоединения.Параметры, ПараметрыСоединения);
	
	Возврат СтруктураСоединения;		
КонецФункции

Функция ПолучитьОтвет(СоединениеИПарметры, АдресРесурса, Метод, Знач ТелоЗапроса = Неопределено, Знач ОбрабатыватьОтвет = Истина) Экспорт 
	
	Соединение = СоединениеИПарметры.Соединение;
	
	//АдресРесурса = "";
	//Если СоединениеИПарметры.Параметры.Свойство("АдресРесурса") Тогда
	//	АдресРесурса = СоединениеИПарметры.Параметры.АдресРесурса; 	
	//КонецЕсли;
	Токен = "";
	Если СоединениеИПарметры.Параметры.Свойство("Токен") Тогда
		Токен = СоединениеИПарметры.Параметры.Токен; 	
	КонецЕсли;
		
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Заголовки.Вставить("Token", Токен);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Если ТелоЗапроса <> Неопределено Тогда
		Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	КонецЕсли;
	
	Если Метод = "GET" Тогда
		Ответ = Соединение.Получить(Запрос);
	ИначеЕсли Метод = "POST" Тогда
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	ИначеЕсли Метод = "PATCH" Тогда
		Ответ = Соединение.Изменить(Запрос);
	ИначеЕсли Метод = "PUT" Тогда
		Ответ = Соединение.Записать(Запрос);
	Иначе 
	 
		ВызватьИсключение "Не определен метод """ + Метод + """";		
	КонецЕсли;
	
	ОтветСтрока = Ответ.ПолучитьТелоКакСтроку();
	
	Если Ответ.КодСостояния >= 300 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Код состояния:" + Ответ.КодСостояния + ". " + ОтветСтрока;
		Сообщение.Сообщить();
	
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ОбрабатыватьОтвет Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураОтвета = ПрочитатьJSONИзСтроки(ОтветСтрока,, "Дата");
	
	Возврат СтруктураОтвета;
	
КонецФункции

Функция ПрочитатьJSONИзСтроки(Текст, ПрочитатьВСоответствие = Ложь, ПоляДаты = "") Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Текст);
	
	Результат = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие, ПоляДаты);
	
	ЧтениеJSON.Закрыть();	
	Возврат Результат;	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьСоединение(ПараметрыСоединения)
	ЗащищенноеСоединение = ?(ПараметрыСоединения.ЭтоЗащищенноеСоединение, Новый ЗащищенноеСоединениеOpenSSL(), Неопределено);
	Порт = ?(ЗначениеЗаполнено(ПараметрыСоединения.Порт), ПараметрыСоединения.Порт, Неопределено);
	//Пользователь = ?(ЗначениеЗаполнено(ПараметрыСоединения.Пользователь), ПараметрыСоединения.Пользователь, Неопределено);
	//Пароль = ?(ЗначениеЗаполнено(ПараметрыСоединения.Пароль), ПараметрыСоединения.Пароль, Неопределено);
	
	Возврат Новый HTTPСоединение(ПараметрыСоединения.Сервер, Порт, ПараметрыСоединения.Пользователь, ПараметрыСоединения.Пароль,, 120, ЗащищенноеСоединение);;		
КонецФункции

#КонецОбласти





