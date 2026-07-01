// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PeopleTable extends People with TableInfo<$PeopleTable, PeopleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CUSTOMER'));
  static const VerificationMeta _startBalanceMeta =
      const VerificationMeta('startBalance');
  @override
  late final GeneratedColumn<double> startBalance = GeneratedColumn<double>(
      'start_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentTermsDaysMeta =
      const VerificationMeta('paymentTermsDays');
  @override
  late final GeneratedColumn<int> paymentTermsDays = GeneratedColumn<int>(
      'payment_terms_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        notes,
        type,
        startBalance,
        startDate,
        creditLimit,
        paymentTermsDays,
        dueDate,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(Insertable<PeopleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('start_balance')) {
      context.handle(
          _startBalanceMeta,
          startBalance.isAcceptableOrUnknown(
              data['start_balance']!, _startBalanceMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('payment_terms_days')) {
      context.handle(
          _paymentTermsDaysMeta,
          paymentTermsDays.isAcceptableOrUnknown(
              data['payment_terms_days']!, _paymentTermsDaysMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeopleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeopleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      startBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_balance'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      paymentTermsDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}payment_terms_days'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class PeopleData extends DataClass implements Insertable<PeopleData> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final String type;
  final double startBalance;
  final String? startDate;
  final double creditLimit;
  final int paymentTermsDays;
  final String? dueDate;
  final int isDeleted;
  const PeopleData(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.type,
      required this.startBalance,
      this.startDate,
      required this.creditLimit,
      required this.paymentTermsDays,
      this.dueDate,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['type'] = Variable<String>(type);
    map['start_balance'] = Variable<double>(startBalance);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    map['credit_limit'] = Variable<double>(creditLimit);
    map['payment_terms_days'] = Variable<int>(paymentTermsDays);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      type: Value(type),
      startBalance: Value(startBalance),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      creditLimit: Value(creditLimit),
      paymentTermsDays: Value(paymentTermsDays),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      isDeleted: Value(isDeleted),
    );
  }

  factory PeopleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeopleData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      type: serializer.fromJson<String>(json['type']),
      startBalance: serializer.fromJson<double>(json['startBalance']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      paymentTermsDays: serializer.fromJson<int>(json['paymentTermsDays']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'type': serializer.toJson<String>(type),
      'startBalance': serializer.toJson<double>(startBalance),
      'startDate': serializer.toJson<String?>(startDate),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'paymentTermsDays': serializer.toJson<int>(paymentTermsDays),
      'dueDate': serializer.toJson<String?>(dueDate),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  PeopleData copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? type,
          double? startBalance,
          Value<String?> startDate = const Value.absent(),
          double? creditLimit,
          int? paymentTermsDays,
          Value<String?> dueDate = const Value.absent(),
          int? isDeleted}) =>
      PeopleData(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        type: type ?? this.type,
        startBalance: startBalance ?? this.startBalance,
        startDate: startDate.present ? startDate.value : this.startDate,
        creditLimit: creditLimit ?? this.creditLimit,
        paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  PeopleData copyWithCompanion(PeopleCompanion data) {
    return PeopleData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      type: data.type.present ? data.type.value : this.type,
      startBalance: data.startBalance.present
          ? data.startBalance.value
          : this.startBalance,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      paymentTermsDays: data.paymentTermsDays.present
          ? data.paymentTermsDays.value
          : this.paymentTermsDays,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeopleData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('startBalance: $startBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      email,
      address,
      notes,
      type,
      startBalance,
      startDate,
      creditLimit,
      paymentTermsDays,
      dueDate,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeopleData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.type == this.type &&
          other.startBalance == this.startBalance &&
          other.startDate == this.startDate &&
          other.creditLimit == this.creditLimit &&
          other.paymentTermsDays == this.paymentTermsDays &&
          other.dueDate == this.dueDate &&
          other.isDeleted == this.isDeleted);
}

class PeopleCompanion extends UpdateCompanion<PeopleData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<String> type;
  final Value<double> startBalance;
  final Value<String?> startDate;
  final Value<double> creditLimit;
  final Value<int> paymentTermsDays;
  final Value<String?> dueDate;
  final Value<int> isDeleted;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.startBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.startBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PeopleData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<String>? type,
    Expression<double>? startBalance,
    Expression<String>? startDate,
    Expression<double>? creditLimit,
    Expression<int>? paymentTermsDays,
    Expression<String>? dueDate,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (type != null) 'type': type,
      if (startBalance != null) 'start_balance': startBalance,
      if (startDate != null) 'start_date': startDate,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (paymentTermsDays != null) 'payment_terms_days': paymentTermsDays,
      if (dueDate != null) 'due_date': dueDate,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PeopleCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<String>? type,
      Value<double>? startBalance,
      Value<String?>? startDate,
      Value<double>? creditLimit,
      Value<int>? paymentTermsDays,
      Value<String?>? dueDate,
      Value<int>? isDeleted}) {
    return PeopleCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      startBalance: startBalance ?? this.startBalance,
      startDate: startDate ?? this.startDate,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
      dueDate: dueDate ?? this.dueDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startBalance.present) {
      map['start_balance'] = Variable<double>(startBalance.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (paymentTermsDays.present) {
      map['payment_terms_days'] = Variable<int>(paymentTermsDays.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('startBalance: $startBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SUPPLIER'));
  static const VerificationMeta _accountCodeMeta =
      const VerificationMeta('accountCode');
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
      'account_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('2100'));
  static const VerificationMeta _expenseCategoryMeta =
      const VerificationMeta('expenseCategory');
  @override
  late final GeneratedColumn<String> expenseCategory = GeneratedColumn<String>(
      'expense_category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentTermsDaysMeta =
      const VerificationMeta('paymentTermsDays');
  @override
  late final GeneratedColumn<int> paymentTermsDays = GeneratedColumn<int>(
      'payment_terms_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _termsMeta = const VerificationMeta('terms');
  @override
  late final GeneratedColumn<String> terms = GeneratedColumn<String>(
      'terms', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        notes,
        type,
        accountCode,
        expenseCategory,
        openingBalance,
        startDate,
        creditLimit,
        paymentTermsDays,
        dueDate,
        terms,
        isDeleted,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('account_code')) {
      context.handle(
          _accountCodeMeta,
          accountCode.isAcceptableOrUnknown(
              data['account_code']!, _accountCodeMeta));
    }
    if (data.containsKey('expense_category')) {
      context.handle(
          _expenseCategoryMeta,
          expenseCategory.isAcceptableOrUnknown(
              data['expense_category']!, _expenseCategoryMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('payment_terms_days')) {
      context.handle(
          _paymentTermsDaysMeta,
          paymentTermsDays.isAcceptableOrUnknown(
              data['payment_terms_days']!, _paymentTermsDaysMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('terms')) {
      context.handle(
          _termsMeta, terms.isAcceptableOrUnknown(data['terms']!, _termsMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      accountCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_code'])!,
      expenseCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}expense_category']),
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      paymentTermsDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}payment_terms_days'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      terms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}terms']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final String type;
  final String accountCode;
  final String? expenseCategory;
  final double openingBalance;
  final String? startDate;
  final double creditLimit;
  final int paymentTermsDays;
  final String? dueDate;
  final String? terms;
  final int isDeleted;
  final String createdAt;
  const Supplier(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.type,
      required this.accountCode,
      this.expenseCategory,
      required this.openingBalance,
      this.startDate,
      required this.creditLimit,
      required this.paymentTermsDays,
      this.dueDate,
      this.terms,
      required this.isDeleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['type'] = Variable<String>(type);
    map['account_code'] = Variable<String>(accountCode);
    if (!nullToAbsent || expenseCategory != null) {
      map['expense_category'] = Variable<String>(expenseCategory);
    }
    map['opening_balance'] = Variable<double>(openingBalance);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    map['credit_limit'] = Variable<double>(creditLimit);
    map['payment_terms_days'] = Variable<int>(paymentTermsDays);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || terms != null) {
      map['terms'] = Variable<String>(terms);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      type: Value(type),
      accountCode: Value(accountCode),
      expenseCategory: expenseCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseCategory),
      openingBalance: Value(openingBalance),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      creditLimit: Value(creditLimit),
      paymentTermsDays: Value(paymentTermsDays),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      terms:
          terms == null && nullToAbsent ? const Value.absent() : Value(terms),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      type: serializer.fromJson<String>(json['type']),
      accountCode: serializer.fromJson<String>(json['accountCode']),
      expenseCategory: serializer.fromJson<String?>(json['expenseCategory']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      paymentTermsDays: serializer.fromJson<int>(json['paymentTermsDays']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      terms: serializer.fromJson<String?>(json['terms']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'type': serializer.toJson<String>(type),
      'accountCode': serializer.toJson<String>(accountCode),
      'expenseCategory': serializer.toJson<String?>(expenseCategory),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'startDate': serializer.toJson<String?>(startDate),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'paymentTermsDays': serializer.toJson<int>(paymentTermsDays),
      'dueDate': serializer.toJson<String?>(dueDate),
      'terms': serializer.toJson<String?>(terms),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? type,
          String? accountCode,
          Value<String?> expenseCategory = const Value.absent(),
          double? openingBalance,
          Value<String?> startDate = const Value.absent(),
          double? creditLimit,
          int? paymentTermsDays,
          Value<String?> dueDate = const Value.absent(),
          Value<String?> terms = const Value.absent(),
          int? isDeleted,
          String? createdAt}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        type: type ?? this.type,
        accountCode: accountCode ?? this.accountCode,
        expenseCategory: expenseCategory.present
            ? expenseCategory.value
            : this.expenseCategory,
        openingBalance: openingBalance ?? this.openingBalance,
        startDate: startDate.present ? startDate.value : this.startDate,
        creditLimit: creditLimit ?? this.creditLimit,
        paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        terms: terms.present ? terms.value : this.terms,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      type: data.type.present ? data.type.value : this.type,
      accountCode:
          data.accountCode.present ? data.accountCode.value : this.accountCode,
      expenseCategory: data.expenseCategory.present
          ? data.expenseCategory.value
          : this.expenseCategory,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      paymentTermsDays: data.paymentTermsDays.present
          ? data.paymentTermsDays.value
          : this.paymentTermsDays,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      terms: data.terms.present ? data.terms.value : this.terms,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('accountCode: $accountCode, ')
          ..write('expenseCategory: $expenseCategory, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('terms: $terms, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      email,
      address,
      notes,
      type,
      accountCode,
      expenseCategory,
      openingBalance,
      startDate,
      creditLimit,
      paymentTermsDays,
      dueDate,
      terms,
      isDeleted,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.type == this.type &&
          other.accountCode == this.accountCode &&
          other.expenseCategory == this.expenseCategory &&
          other.openingBalance == this.openingBalance &&
          other.startDate == this.startDate &&
          other.creditLimit == this.creditLimit &&
          other.paymentTermsDays == this.paymentTermsDays &&
          other.dueDate == this.dueDate &&
          other.terms == this.terms &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<String> type;
  final Value<String> accountCode;
  final Value<String?> expenseCategory;
  final Value<double> openingBalance;
  final Value<String?> startDate;
  final Value<double> creditLimit;
  final Value<int> paymentTermsDays;
  final Value<String?> dueDate;
  final Value<String?> terms;
  final Value<int> isDeleted;
  final Value<String> createdAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.expenseCategory = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.terms = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.expenseCategory = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.terms = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String createdAt,
  })  : name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<String>? type,
    Expression<String>? accountCode,
    Expression<String>? expenseCategory,
    Expression<double>? openingBalance,
    Expression<String>? startDate,
    Expression<double>? creditLimit,
    Expression<int>? paymentTermsDays,
    Expression<String>? dueDate,
    Expression<String>? terms,
    Expression<int>? isDeleted,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (type != null) 'type': type,
      if (accountCode != null) 'account_code': accountCode,
      if (expenseCategory != null) 'expense_category': expenseCategory,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (startDate != null) 'start_date': startDate,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (paymentTermsDays != null) 'payment_terms_days': paymentTermsDays,
      if (dueDate != null) 'due_date': dueDate,
      if (terms != null) 'terms': terms,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<String>? type,
      Value<String>? accountCode,
      Value<String?>? expenseCategory,
      Value<double>? openingBalance,
      Value<String?>? startDate,
      Value<double>? creditLimit,
      Value<int>? paymentTermsDays,
      Value<String?>? dueDate,
      Value<String?>? terms,
      Value<int>? isDeleted,
      Value<String>? createdAt}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      accountCode: accountCode ?? this.accountCode,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      openingBalance: openingBalance ?? this.openingBalance,
      startDate: startDate ?? this.startDate,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
      dueDate: dueDate ?? this.dueDate,
      terms: terms ?? this.terms,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (expenseCategory.present) {
      map['expense_category'] = Variable<String>(expenseCategory.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (paymentTermsDays.present) {
      map['payment_terms_days'] = Variable<int>(paymentTermsDays.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (terms.present) {
      map['terms'] = Variable<String>(terms.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('accountCode: $accountCode, ')
          ..write('expenseCategory: $expenseCategory, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('terms: $terms, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _trackStockMeta =
      const VerificationMeta('trackStock');
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
      'track_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("track_stock" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _avgCostMeta =
      const VerificationMeta('avgCost');
  @override
  late final GeneratedColumn<double> avgCost = GeneratedColumn<double>(
      'avg_cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _reorderLevelMeta =
      const VerificationMeta('reorderLevel');
  @override
  late final GeneratedColumn<double> reorderLevel = GeneratedColumn<double>(
      'reorder_level', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(10.0));
  static const VerificationMeta _bundle1QtyMeta =
      const VerificationMeta('bundle1Qty');
  @override
  late final GeneratedColumn<double> bundle1Qty = GeneratedColumn<double>(
      'bundle1_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle1PriceMeta =
      const VerificationMeta('bundle1Price');
  @override
  late final GeneratedColumn<double> bundle1Price = GeneratedColumn<double>(
      'bundle1_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle2QtyMeta =
      const VerificationMeta('bundle2Qty');
  @override
  late final GeneratedColumn<double> bundle2Qty = GeneratedColumn<double>(
      'bundle2_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle2PriceMeta =
      const VerificationMeta('bundle2Price');
  @override
  late final GeneratedColumn<double> bundle2Price = GeneratedColumn<double>(
      'bundle2_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle3QtyMeta =
      const VerificationMeta('bundle3Qty');
  @override
  late final GeneratedColumn<double> bundle3Qty = GeneratedColumn<double>(
      'bundle3_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle3PriceMeta =
      const VerificationMeta('bundle3Price');
  @override
  late final GeneratedColumn<double> bundle3Price = GeneratedColumn<double>(
      'bundle3_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle4QtyMeta =
      const VerificationMeta('bundle4Qty');
  @override
  late final GeneratedColumn<double> bundle4Qty = GeneratedColumn<double>(
      'bundle4_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle4PriceMeta =
      const VerificationMeta('bundle4Price');
  @override
  late final GeneratedColumn<double> bundle4Price = GeneratedColumn<double>(
      'bundle4_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle5QtyMeta =
      const VerificationMeta('bundle5Qty');
  @override
  late final GeneratedColumn<double> bundle5Qty = GeneratedColumn<double>(
      'bundle5_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle5PriceMeta =
      const VerificationMeta('bundle5Price');
  @override
  late final GeneratedColumn<double> bundle5Price = GeneratedColumn<double>(
      'bundle5_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        price,
        category,
        trackStock,
        currentStock,
        avgCost,
        reorderLevel,
        bundle1Qty,
        bundle1Price,
        bundle2Qty,
        bundle2Price,
        bundle3Qty,
        bundle3Price,
        bundle4Qty,
        bundle4Price,
        bundle5Qty,
        bundle5Price,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('track_stock')) {
      context.handle(
          _trackStockMeta,
          trackStock.isAcceptableOrUnknown(
              data['track_stock']!, _trackStockMeta));
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    }
    if (data.containsKey('avg_cost')) {
      context.handle(_avgCostMeta,
          avgCost.isAcceptableOrUnknown(data['avg_cost']!, _avgCostMeta));
    }
    if (data.containsKey('reorder_level')) {
      context.handle(
          _reorderLevelMeta,
          reorderLevel.isAcceptableOrUnknown(
              data['reorder_level']!, _reorderLevelMeta));
    }
    if (data.containsKey('bundle1_qty')) {
      context.handle(
          _bundle1QtyMeta,
          bundle1Qty.isAcceptableOrUnknown(
              data['bundle1_qty']!, _bundle1QtyMeta));
    }
    if (data.containsKey('bundle1_price')) {
      context.handle(
          _bundle1PriceMeta,
          bundle1Price.isAcceptableOrUnknown(
              data['bundle1_price']!, _bundle1PriceMeta));
    }
    if (data.containsKey('bundle2_qty')) {
      context.handle(
          _bundle2QtyMeta,
          bundle2Qty.isAcceptableOrUnknown(
              data['bundle2_qty']!, _bundle2QtyMeta));
    }
    if (data.containsKey('bundle2_price')) {
      context.handle(
          _bundle2PriceMeta,
          bundle2Price.isAcceptableOrUnknown(
              data['bundle2_price']!, _bundle2PriceMeta));
    }
    if (data.containsKey('bundle3_qty')) {
      context.handle(
          _bundle3QtyMeta,
          bundle3Qty.isAcceptableOrUnknown(
              data['bundle3_qty']!, _bundle3QtyMeta));
    }
    if (data.containsKey('bundle3_price')) {
      context.handle(
          _bundle3PriceMeta,
          bundle3Price.isAcceptableOrUnknown(
              data['bundle3_price']!, _bundle3PriceMeta));
    }
    if (data.containsKey('bundle4_qty')) {
      context.handle(
          _bundle4QtyMeta,
          bundle4Qty.isAcceptableOrUnknown(
              data['bundle4_qty']!, _bundle4QtyMeta));
    }
    if (data.containsKey('bundle4_price')) {
      context.handle(
          _bundle4PriceMeta,
          bundle4Price.isAcceptableOrUnknown(
              data['bundle4_price']!, _bundle4PriceMeta));
    }
    if (data.containsKey('bundle5_qty')) {
      context.handle(
          _bundle5QtyMeta,
          bundle5Qty.isAcceptableOrUnknown(
              data['bundle5_qty']!, _bundle5QtyMeta));
    }
    if (data.containsKey('bundle5_price')) {
      context.handle(
          _bundle5PriceMeta,
          bundle5Price.isAcceptableOrUnknown(
              data['bundle5_price']!, _bundle5PriceMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      trackStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}track_stock'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_stock'])!,
      avgCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_cost'])!,
      reorderLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reorder_level'])!,
      bundle1Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle1_qty'])!,
      bundle1Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle1_price'])!,
      bundle2Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle2_qty'])!,
      bundle2Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle2_price'])!,
      bundle3Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle3_qty'])!,
      bundle3Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle3_price'])!,
      bundle4Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle4_qty'])!,
      bundle4Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle4_price'])!,
      bundle5Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle5_qty'])!,
      bundle5Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle5_price'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? category;
  final bool trackStock;
  final double currentStock;
  final double avgCost;
  final double reorderLevel;
  final double bundle1Qty;
  final double bundle1Price;
  final double bundle2Qty;
  final double bundle2Price;
  final double bundle3Qty;
  final double bundle3Price;
  final double bundle4Qty;
  final double bundle4Price;
  final double bundle5Qty;
  final double bundle5Price;
  final int isDeleted;
  const Product(
      {required this.id,
      required this.name,
      this.description,
      required this.price,
      this.category,
      required this.trackStock,
      required this.currentStock,
      required this.avgCost,
      required this.reorderLevel,
      required this.bundle1Qty,
      required this.bundle1Price,
      required this.bundle2Qty,
      required this.bundle2Price,
      required this.bundle3Qty,
      required this.bundle3Price,
      required this.bundle4Qty,
      required this.bundle4Price,
      required this.bundle5Qty,
      required this.bundle5Price,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['track_stock'] = Variable<bool>(trackStock);
    map['current_stock'] = Variable<double>(currentStock);
    map['avg_cost'] = Variable<double>(avgCost);
    map['reorder_level'] = Variable<double>(reorderLevel);
    map['bundle1_qty'] = Variable<double>(bundle1Qty);
    map['bundle1_price'] = Variable<double>(bundle1Price);
    map['bundle2_qty'] = Variable<double>(bundle2Qty);
    map['bundle2_price'] = Variable<double>(bundle2Price);
    map['bundle3_qty'] = Variable<double>(bundle3Qty);
    map['bundle3_price'] = Variable<double>(bundle3Price);
    map['bundle4_qty'] = Variable<double>(bundle4Qty);
    map['bundle4_price'] = Variable<double>(bundle4Price);
    map['bundle5_qty'] = Variable<double>(bundle5Qty);
    map['bundle5_price'] = Variable<double>(bundle5Price);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      trackStock: Value(trackStock),
      currentStock: Value(currentStock),
      avgCost: Value(avgCost),
      reorderLevel: Value(reorderLevel),
      bundle1Qty: Value(bundle1Qty),
      bundle1Price: Value(bundle1Price),
      bundle2Qty: Value(bundle2Qty),
      bundle2Price: Value(bundle2Price),
      bundle3Qty: Value(bundle3Qty),
      bundle3Price: Value(bundle3Price),
      bundle4Qty: Value(bundle4Qty),
      bundle4Price: Value(bundle4Price),
      bundle5Qty: Value(bundle5Qty),
      bundle5Price: Value(bundle5Price),
      isDeleted: Value(isDeleted),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String?>(json['category']),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      avgCost: serializer.fromJson<double>(json['avgCost']),
      reorderLevel: serializer.fromJson<double>(json['reorderLevel']),
      bundle1Qty: serializer.fromJson<double>(json['bundle1Qty']),
      bundle1Price: serializer.fromJson<double>(json['bundle1Price']),
      bundle2Qty: serializer.fromJson<double>(json['bundle2Qty']),
      bundle2Price: serializer.fromJson<double>(json['bundle2Price']),
      bundle3Qty: serializer.fromJson<double>(json['bundle3Qty']),
      bundle3Price: serializer.fromJson<double>(json['bundle3Price']),
      bundle4Qty: serializer.fromJson<double>(json['bundle4Qty']),
      bundle4Price: serializer.fromJson<double>(json['bundle4Price']),
      bundle5Qty: serializer.fromJson<double>(json['bundle5Qty']),
      bundle5Price: serializer.fromJson<double>(json['bundle5Price']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String?>(category),
      'trackStock': serializer.toJson<bool>(trackStock),
      'currentStock': serializer.toJson<double>(currentStock),
      'avgCost': serializer.toJson<double>(avgCost),
      'reorderLevel': serializer.toJson<double>(reorderLevel),
      'bundle1Qty': serializer.toJson<double>(bundle1Qty),
      'bundle1Price': serializer.toJson<double>(bundle1Price),
      'bundle2Qty': serializer.toJson<double>(bundle2Qty),
      'bundle2Price': serializer.toJson<double>(bundle2Price),
      'bundle3Qty': serializer.toJson<double>(bundle3Qty),
      'bundle3Price': serializer.toJson<double>(bundle3Price),
      'bundle4Qty': serializer.toJson<double>(bundle4Qty),
      'bundle4Price': serializer.toJson<double>(bundle4Price),
      'bundle5Qty': serializer.toJson<double>(bundle5Qty),
      'bundle5Price': serializer.toJson<double>(bundle5Price),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          double? price,
          Value<String?> category = const Value.absent(),
          bool? trackStock,
          double? currentStock,
          double? avgCost,
          double? reorderLevel,
          double? bundle1Qty,
          double? bundle1Price,
          double? bundle2Qty,
          double? bundle2Price,
          double? bundle3Qty,
          double? bundle3Price,
          double? bundle4Qty,
          double? bundle4Price,
          double? bundle5Qty,
          double? bundle5Price,
          int? isDeleted}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        price: price ?? this.price,
        category: category.present ? category.value : this.category,
        trackStock: trackStock ?? this.trackStock,
        currentStock: currentStock ?? this.currentStock,
        avgCost: avgCost ?? this.avgCost,
        reorderLevel: reorderLevel ?? this.reorderLevel,
        bundle1Qty: bundle1Qty ?? this.bundle1Qty,
        bundle1Price: bundle1Price ?? this.bundle1Price,
        bundle2Qty: bundle2Qty ?? this.bundle2Qty,
        bundle2Price: bundle2Price ?? this.bundle2Price,
        bundle3Qty: bundle3Qty ?? this.bundle3Qty,
        bundle3Price: bundle3Price ?? this.bundle3Price,
        bundle4Qty: bundle4Qty ?? this.bundle4Qty,
        bundle4Price: bundle4Price ?? this.bundle4Price,
        bundle5Qty: bundle5Qty ?? this.bundle5Qty,
        bundle5Price: bundle5Price ?? this.bundle5Price,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      trackStock:
          data.trackStock.present ? data.trackStock.value : this.trackStock,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      avgCost: data.avgCost.present ? data.avgCost.value : this.avgCost,
      reorderLevel: data.reorderLevel.present
          ? data.reorderLevel.value
          : this.reorderLevel,
      bundle1Qty:
          data.bundle1Qty.present ? data.bundle1Qty.value : this.bundle1Qty,
      bundle1Price: data.bundle1Price.present
          ? data.bundle1Price.value
          : this.bundle1Price,
      bundle2Qty:
          data.bundle2Qty.present ? data.bundle2Qty.value : this.bundle2Qty,
      bundle2Price: data.bundle2Price.present
          ? data.bundle2Price.value
          : this.bundle2Price,
      bundle3Qty:
          data.bundle3Qty.present ? data.bundle3Qty.value : this.bundle3Qty,
      bundle3Price: data.bundle3Price.present
          ? data.bundle3Price.value
          : this.bundle3Price,
      bundle4Qty:
          data.bundle4Qty.present ? data.bundle4Qty.value : this.bundle4Qty,
      bundle4Price: data.bundle4Price.present
          ? data.bundle4Price.value
          : this.bundle4Price,
      bundle5Qty:
          data.bundle5Qty.present ? data.bundle5Qty.value : this.bundle5Qty,
      bundle5Price: data.bundle5Price.present
          ? data.bundle5Price.value
          : this.bundle5Price,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('avgCost: $avgCost, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('bundle1Qty: $bundle1Qty, ')
          ..write('bundle1Price: $bundle1Price, ')
          ..write('bundle2Qty: $bundle2Qty, ')
          ..write('bundle2Price: $bundle2Price, ')
          ..write('bundle3Qty: $bundle3Qty, ')
          ..write('bundle3Price: $bundle3Price, ')
          ..write('bundle4Qty: $bundle4Qty, ')
          ..write('bundle4Price: $bundle4Price, ')
          ..write('bundle5Qty: $bundle5Qty, ')
          ..write('bundle5Price: $bundle5Price, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      price,
      category,
      trackStock,
      currentStock,
      avgCost,
      reorderLevel,
      bundle1Qty,
      bundle1Price,
      bundle2Qty,
      bundle2Price,
      bundle3Qty,
      bundle3Price,
      bundle4Qty,
      bundle4Price,
      bundle5Qty,
      bundle5Price,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.category == this.category &&
          other.trackStock == this.trackStock &&
          other.currentStock == this.currentStock &&
          other.avgCost == this.avgCost &&
          other.reorderLevel == this.reorderLevel &&
          other.bundle1Qty == this.bundle1Qty &&
          other.bundle1Price == this.bundle1Price &&
          other.bundle2Qty == this.bundle2Qty &&
          other.bundle2Price == this.bundle2Price &&
          other.bundle3Qty == this.bundle3Qty &&
          other.bundle3Price == this.bundle3Price &&
          other.bundle4Qty == this.bundle4Qty &&
          other.bundle4Price == this.bundle4Price &&
          other.bundle5Qty == this.bundle5Qty &&
          other.bundle5Price == this.bundle5Price &&
          other.isDeleted == this.isDeleted);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> price;
  final Value<String?> category;
  final Value<bool> trackStock;
  final Value<double> currentStock;
  final Value<double> avgCost;
  final Value<double> reorderLevel;
  final Value<double> bundle1Qty;
  final Value<double> bundle1Price;
  final Value<double> bundle2Qty;
  final Value<double> bundle2Price;
  final Value<double> bundle3Qty;
  final Value<double> bundle3Price;
  final Value<double> bundle4Qty;
  final Value<double> bundle4Price;
  final Value<double> bundle5Qty;
  final Value<double> bundle5Price;
  final Value<int> isDeleted;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.avgCost = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.bundle1Qty = const Value.absent(),
    this.bundle1Price = const Value.absent(),
    this.bundle2Qty = const Value.absent(),
    this.bundle2Price = const Value.absent(),
    this.bundle3Qty = const Value.absent(),
    this.bundle3Price = const Value.absent(),
    this.bundle4Qty = const Value.absent(),
    this.bundle4Price = const Value.absent(),
    this.bundle5Qty = const Value.absent(),
    this.bundle5Price = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required double price,
    this.category = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.avgCost = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.bundle1Qty = const Value.absent(),
    this.bundle1Price = const Value.absent(),
    this.bundle2Qty = const Value.absent(),
    this.bundle2Price = const Value.absent(),
    this.bundle3Qty = const Value.absent(),
    this.bundle3Price = const Value.absent(),
    this.bundle4Qty = const Value.absent(),
    this.bundle4Price = const Value.absent(),
    this.bundle5Qty = const Value.absent(),
    this.bundle5Price = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : name = Value(name),
        price = Value(price);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<String>? category,
    Expression<bool>? trackStock,
    Expression<double>? currentStock,
    Expression<double>? avgCost,
    Expression<double>? reorderLevel,
    Expression<double>? bundle1Qty,
    Expression<double>? bundle1Price,
    Expression<double>? bundle2Qty,
    Expression<double>? bundle2Price,
    Expression<double>? bundle3Qty,
    Expression<double>? bundle3Price,
    Expression<double>? bundle4Qty,
    Expression<double>? bundle4Price,
    Expression<double>? bundle5Qty,
    Expression<double>? bundle5Price,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (trackStock != null) 'track_stock': trackStock,
      if (currentStock != null) 'current_stock': currentStock,
      if (avgCost != null) 'avg_cost': avgCost,
      if (reorderLevel != null) 'reorder_level': reorderLevel,
      if (bundle1Qty != null) 'bundle1_qty': bundle1Qty,
      if (bundle1Price != null) 'bundle1_price': bundle1Price,
      if (bundle2Qty != null) 'bundle2_qty': bundle2Qty,
      if (bundle2Price != null) 'bundle2_price': bundle2Price,
      if (bundle3Qty != null) 'bundle3_qty': bundle3Qty,
      if (bundle3Price != null) 'bundle3_price': bundle3Price,
      if (bundle4Qty != null) 'bundle4_qty': bundle4Qty,
      if (bundle4Price != null) 'bundle4_price': bundle4Price,
      if (bundle5Qty != null) 'bundle5_qty': bundle5Qty,
      if (bundle5Price != null) 'bundle5_price': bundle5Price,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? price,
      Value<String?>? category,
      Value<bool>? trackStock,
      Value<double>? currentStock,
      Value<double>? avgCost,
      Value<double>? reorderLevel,
      Value<double>? bundle1Qty,
      Value<double>? bundle1Price,
      Value<double>? bundle2Qty,
      Value<double>? bundle2Price,
      Value<double>? bundle3Qty,
      Value<double>? bundle3Price,
      Value<double>? bundle4Qty,
      Value<double>? bundle4Price,
      Value<double>? bundle5Qty,
      Value<double>? bundle5Price,
      Value<int>? isDeleted}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      trackStock: trackStock ?? this.trackStock,
      currentStock: currentStock ?? this.currentStock,
      avgCost: avgCost ?? this.avgCost,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      bundle1Qty: bundle1Qty ?? this.bundle1Qty,
      bundle1Price: bundle1Price ?? this.bundle1Price,
      bundle2Qty: bundle2Qty ?? this.bundle2Qty,
      bundle2Price: bundle2Price ?? this.bundle2Price,
      bundle3Qty: bundle3Qty ?? this.bundle3Qty,
      bundle3Price: bundle3Price ?? this.bundle3Price,
      bundle4Qty: bundle4Qty ?? this.bundle4Qty,
      bundle4Price: bundle4Price ?? this.bundle4Price,
      bundle5Qty: bundle5Qty ?? this.bundle5Qty,
      bundle5Price: bundle5Price ?? this.bundle5Price,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (avgCost.present) {
      map['avg_cost'] = Variable<double>(avgCost.value);
    }
    if (reorderLevel.present) {
      map['reorder_level'] = Variable<double>(reorderLevel.value);
    }
    if (bundle1Qty.present) {
      map['bundle1_qty'] = Variable<double>(bundle1Qty.value);
    }
    if (bundle1Price.present) {
      map['bundle1_price'] = Variable<double>(bundle1Price.value);
    }
    if (bundle2Qty.present) {
      map['bundle2_qty'] = Variable<double>(bundle2Qty.value);
    }
    if (bundle2Price.present) {
      map['bundle2_price'] = Variable<double>(bundle2Price.value);
    }
    if (bundle3Qty.present) {
      map['bundle3_qty'] = Variable<double>(bundle3Qty.value);
    }
    if (bundle3Price.present) {
      map['bundle3_price'] = Variable<double>(bundle3Price.value);
    }
    if (bundle4Qty.present) {
      map['bundle4_qty'] = Variable<double>(bundle4Qty.value);
    }
    if (bundle4Price.present) {
      map['bundle4_price'] = Variable<double>(bundle4Price.value);
    }
    if (bundle5Qty.present) {
      map['bundle5_qty'] = Variable<double>(bundle5Qty.value);
    }
    if (bundle5Price.present) {
      map['bundle5_price'] = Variable<double>(bundle5Price.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('avgCost: $avgCost, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('bundle1Qty: $bundle1Qty, ')
          ..write('bundle1Price: $bundle1Price, ')
          ..write('bundle2Qty: $bundle2Qty, ')
          ..write('bundle2Price: $bundle2Price, ')
          ..write('bundle3Qty: $bundle3Qty, ')
          ..write('bundle3Price: $bundle3Price, ')
          ..write('bundle4Qty: $bundle4Qty, ')
          ..write('bundle4Price: $bundle4Price, ')
          ..write('bundle5Qty: $bundle5Qty, ')
          ..write('bundle5Price: $bundle5Price, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saleTypeMeta =
      const VerificationMeta('saleType');
  @override
  late final GeneratedColumn<String> saleType = GeneratedColumn<String>(
      'sale_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CREDIT'));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NORMAL'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personId,
        invoiceNumber,
        date,
        dueDate,
        saleType,
        total,
        status,
        notes,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('sale_type')) {
      context.handle(_saleTypeMeta,
          saleType.isAcceptableOrUnknown(data['sale_type']!, _saleTypeMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      saleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_type'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final int personId;
  final String invoiceNumber;
  final String date;
  final String? dueDate;
  final String saleType;
  final double total;
  final String status;
  final String? notes;
  final int isDeleted;
  const Sale(
      {required this.id,
      required this.personId,
      required this.invoiceNumber,
      required this.date,
      this.dueDate,
      required this.saleType,
      required this.total,
      required this.status,
      this.notes,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['sale_type'] = Variable<String>(saleType);
    map['total'] = Variable<double>(total);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      personId: Value(personId),
      invoiceNumber: Value(invoiceNumber),
      date: Value(date),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      saleType: Value(saleType),
      total: Value(total),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isDeleted: Value(isDeleted),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      date: serializer.fromJson<String>(json['date']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      saleType: serializer.fromJson<String>(json['saleType']),
      total: serializer.fromJson<double>(json['total']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'date': serializer.toJson<String>(date),
      'dueDate': serializer.toJson<String?>(dueDate),
      'saleType': serializer.toJson<String>(saleType),
      'total': serializer.toJson<double>(total),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Sale copyWith(
          {int? id,
          int? personId,
          String? invoiceNumber,
          String? date,
          Value<String?> dueDate = const Value.absent(),
          String? saleType,
          double? total,
          String? status,
          Value<String?> notes = const Value.absent(),
          int? isDeleted}) =>
      Sale(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        date: date ?? this.date,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        saleType: saleType ?? this.saleType,
        total: total ?? this.total,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      date: data.date.present ? data.date.value : this.date,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      saleType: data.saleType.present ? data.saleType.value : this.saleType,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('saleType: $saleType, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personId, invoiceNumber, date, dueDate,
      saleType, total, status, notes, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.date == this.date &&
          other.dueDate == this.dueDate &&
          other.saleType == this.saleType &&
          other.total == this.total &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isDeleted == this.isDeleted);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> invoiceNumber;
  final Value<String> date;
  final Value<String?> dueDate;
  final Value<String> saleType;
  final Value<double> total;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> isDeleted;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.saleType = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required String invoiceNumber,
    required String date,
    this.dueDate = const Value.absent(),
    this.saleType = const Value.absent(),
    required double total,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : personId = Value(personId),
        invoiceNumber = Value(invoiceNumber),
        date = Value(date),
        total = Value(total);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? invoiceNumber,
    Expression<String>? date,
    Expression<String>? dueDate,
    Expression<String>? saleType,
    Expression<double>? total,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (date != null) 'date': date,
      if (dueDate != null) 'due_date': dueDate,
      if (saleType != null) 'sale_type': saleType,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<int>? personId,
      Value<String>? invoiceNumber,
      Value<String>? date,
      Value<String?>? dueDate,
      Value<String>? saleType,
      Value<double>? total,
      Value<String>? status,
      Value<String?>? notes,
      Value<int>? isDeleted}) {
    return SalesCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      saleType: saleType ?? this.saleType,
      total: total ?? this.total,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (saleType.present) {
      map['sale_type'] = Variable<String>(saleType.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('saleType: $saleType, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costOfGoodsMeta =
      const VerificationMeta('costOfGoods');
  @override
  late final GeneratedColumn<double> costOfGoods = GeneratedColumn<double>(
      'cost_of_goods', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleId, productId, quantity, price, total, costOfGoods];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('cost_of_goods')) {
      context.handle(
          _costOfGoodsMeta,
          costOfGoods.isAcceptableOrUnknown(
              data['cost_of_goods']!, _costOfGoodsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      costOfGoods: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_of_goods'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int productId;
  final double quantity;
  final double price;
  final double total;
  final double costOfGoods;
  const SaleItem(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.total,
      required this.costOfGoods});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['total'] = Variable<double>(total);
    map['cost_of_goods'] = Variable<double>(costOfGoods);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      price: Value(price),
      total: Value(total),
      costOfGoods: Value(costOfGoods),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      total: serializer.fromJson<double>(json['total']),
      costOfGoods: serializer.fromJson<double>(json['costOfGoods']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'total': serializer.toJson<double>(total),
      'costOfGoods': serializer.toJson<double>(costOfGoods),
    };
  }

  SaleItem copyWith(
          {int? id,
          int? saleId,
          int? productId,
          double? quantity,
          double? price,
          double? total,
          double? costOfGoods}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        total: total ?? this.total,
        costOfGoods: costOfGoods ?? this.costOfGoods,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      total: data.total.present ? data.total.value : this.total,
      costOfGoods:
          data.costOfGoods.present ? data.costOfGoods.value : this.costOfGoods,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('costOfGoods: $costOfGoods')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, productId, quantity, price, total, costOfGoods);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.total == this.total &&
          other.costOfGoods == this.costOfGoods);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> productId;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> total;
  final Value<double> costOfGoods;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.total = const Value.absent(),
    this.costOfGoods = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int productId,
    required double quantity,
    required double price,
    required double total,
    this.costOfGoods = const Value.absent(),
  })  : saleId = Value(saleId),
        productId = Value(productId),
        quantity = Value(quantity),
        price = Value(price),
        total = Value(total);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? total,
    Expression<double>? costOfGoods,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (total != null) 'total': total,
      if (costOfGoods != null) 'cost_of_goods': costOfGoods,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleId,
      Value<int>? productId,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? total,
      Value<double>? costOfGoods}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      costOfGoods: costOfGoods ?? this.costOfGoods,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (costOfGoods.present) {
      map['cost_of_goods'] = Variable<double>(costOfGoods.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('costOfGoods: $costOfGoods')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentTypeMeta =
      const VerificationMeta('paymentType');
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
      'payment_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CUSTOMER_RECEIPT'));
  static const VerificationMeta _receiptTypeMeta =
      const VerificationMeta('receiptType');
  @override
  late final GeneratedColumn<String> receiptType = GeneratedColumn<String>(
      'receipt_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CREDIT_RECEIPT'));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personId,
        date,
        amount,
        paymentType,
        receiptType,
        paymentMethod,
        reference,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
          _paymentTypeMeta,
          paymentType.isAcceptableOrUnknown(
              data['payment_type']!, _paymentTypeMeta));
    }
    if (data.containsKey('receipt_type')) {
      context.handle(
          _receiptTypeMeta,
          receiptType.isAcceptableOrUnknown(
              data['receipt_type']!, _receiptTypeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_type'])!,
      receiptType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_type'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int personId;
  final String date;
  final double amount;
  final String paymentType;
  final String receiptType;
  final String paymentMethod;
  final String? reference;
  final int isDeleted;
  const Payment(
      {required this.id,
      required this.personId,
      required this.date,
      required this.amount,
      required this.paymentType,
      required this.receiptType,
      required this.paymentMethod,
      this.reference,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['date'] = Variable<String>(date);
    map['amount'] = Variable<double>(amount);
    map['payment_type'] = Variable<String>(paymentType);
    map['receipt_type'] = Variable<String>(receiptType);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      personId: Value(personId),
      date: Value(date),
      amount: Value(amount),
      paymentType: Value(paymentType),
      receiptType: Value(receiptType),
      paymentMethod: Value(paymentMethod),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      isDeleted: Value(isDeleted),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      date: serializer.fromJson<String>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      receiptType: serializer.fromJson<String>(json['receiptType']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      reference: serializer.fromJson<String?>(json['reference']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'date': serializer.toJson<String>(date),
      'amount': serializer.toJson<double>(amount),
      'paymentType': serializer.toJson<String>(paymentType),
      'receiptType': serializer.toJson<String>(receiptType),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'reference': serializer.toJson<String?>(reference),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Payment copyWith(
          {int? id,
          int? personId,
          String? date,
          double? amount,
          String? paymentType,
          String? receiptType,
          String? paymentMethod,
          Value<String?> reference = const Value.absent(),
          int? isDeleted}) =>
      Payment(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        paymentType: paymentType ?? this.paymentType,
        receiptType: receiptType ?? this.receiptType,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        reference: reference.present ? reference.value : this.reference,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentType:
          data.paymentType.present ? data.paymentType.value : this.paymentType,
      receiptType:
          data.receiptType.present ? data.receiptType.value : this.receiptType,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      reference: data.reference.present ? data.reference.value : this.reference,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('paymentType: $paymentType, ')
          ..write('receiptType: $receiptType, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personId, date, amount, paymentType,
      receiptType, paymentMethod, reference, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.paymentType == this.paymentType &&
          other.receiptType == this.receiptType &&
          other.paymentMethod == this.paymentMethod &&
          other.reference == this.reference &&
          other.isDeleted == this.isDeleted);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> date;
  final Value<double> amount;
  final Value<String> paymentType;
  final Value<String> receiptType;
  final Value<String> paymentMethod;
  final Value<String?> reference;
  final Value<int> isDeleted;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.receiptType = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required String date,
    required double amount,
    this.paymentType = const Value.absent(),
    this.receiptType = const Value.absent(),
    required String paymentMethod,
    this.reference = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : personId = Value(personId),
        date = Value(date),
        amount = Value(amount),
        paymentMethod = Value(paymentMethod);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? date,
    Expression<double>? amount,
    Expression<String>? paymentType,
    Expression<String>? receiptType,
    Expression<String>? paymentMethod,
    Expression<String>? reference,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (paymentType != null) 'payment_type': paymentType,
      if (receiptType != null) 'receipt_type': receiptType,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (reference != null) 'reference': reference,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personId,
      Value<String>? date,
      Value<double>? amount,
      Value<String>? paymentType,
      Value<String>? receiptType,
      Value<String>? paymentMethod,
      Value<String?>? reference,
      Value<int>? isDeleted}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      paymentType: paymentType ?? this.paymentType,
      receiptType: receiptType ?? this.receiptType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (receiptType.present) {
      map['receipt_type'] = Variable<String>(receiptType.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('paymentType: $paymentType, ')
          ..write('receiptType: $receiptType, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $AllocationsTable extends Allocations
    with TableInfo<$AllocationsTable, Allocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _paymentIdMeta =
      const VerificationMeta('paymentId');
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
      'payment_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allocatedItemIdMeta =
      const VerificationMeta('allocatedItemId');
  @override
  late final GeneratedColumn<int> allocatedItemId = GeneratedColumn<int>(
      'allocated_item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allocatedItemTypeMeta =
      const VerificationMeta('allocatedItemType');
  @override
  late final GeneratedColumn<String> allocatedItemType =
      GeneratedColumn<String>('allocated_item_type', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('SALE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, paymentId, allocatedItemId, allocatedItemType, amount, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocations';
  @override
  VerificationContext validateIntegrity(Insertable<Allocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta));
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('allocated_item_id')) {
      context.handle(
          _allocatedItemIdMeta,
          allocatedItemId.isAcceptableOrUnknown(
              data['allocated_item_id']!, _allocatedItemIdMeta));
    } else if (isInserting) {
      context.missing(_allocatedItemIdMeta);
    }
    if (data.containsKey('allocated_item_type')) {
      context.handle(
          _allocatedItemTypeMeta,
          allocatedItemType.isAcceptableOrUnknown(
              data['allocated_item_type']!, _allocatedItemTypeMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Allocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Allocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      paymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_id'])!,
      allocatedItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}allocated_item_id'])!,
      allocatedItemType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}allocated_item_type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AllocationsTable createAlias(String alias) {
    return $AllocationsTable(attachedDatabase, alias);
  }
}

class Allocation extends DataClass implements Insertable<Allocation> {
  final int id;
  final int paymentId;
  final int allocatedItemId;
  final String allocatedItemType;
  final double amount;
  final int isActive;
  const Allocation(
      {required this.id,
      required this.paymentId,
      required this.allocatedItemId,
      required this.allocatedItemType,
      required this.amount,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_id'] = Variable<int>(paymentId);
    map['allocated_item_id'] = Variable<int>(allocatedItemId);
    map['allocated_item_type'] = Variable<String>(allocatedItemType);
    map['amount'] = Variable<double>(amount);
    map['is_active'] = Variable<int>(isActive);
    return map;
  }

  AllocationsCompanion toCompanion(bool nullToAbsent) {
    return AllocationsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      allocatedItemId: Value(allocatedItemId),
      allocatedItemType: Value(allocatedItemType),
      amount: Value(amount),
      isActive: Value(isActive),
    );
  }

  factory Allocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Allocation(
      id: serializer.fromJson<int>(json['id']),
      paymentId: serializer.fromJson<int>(json['paymentId']),
      allocatedItemId: serializer.fromJson<int>(json['allocatedItemId']),
      allocatedItemType: serializer.fromJson<String>(json['allocatedItemType']),
      amount: serializer.fromJson<double>(json['amount']),
      isActive: serializer.fromJson<int>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentId': serializer.toJson<int>(paymentId),
      'allocatedItemId': serializer.toJson<int>(allocatedItemId),
      'allocatedItemType': serializer.toJson<String>(allocatedItemType),
      'amount': serializer.toJson<double>(amount),
      'isActive': serializer.toJson<int>(isActive),
    };
  }

  Allocation copyWith(
          {int? id,
          int? paymentId,
          int? allocatedItemId,
          String? allocatedItemType,
          double? amount,
          int? isActive}) =>
      Allocation(
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        allocatedItemId: allocatedItemId ?? this.allocatedItemId,
        allocatedItemType: allocatedItemType ?? this.allocatedItemType,
        amount: amount ?? this.amount,
        isActive: isActive ?? this.isActive,
      );
  Allocation copyWithCompanion(AllocationsCompanion data) {
    return Allocation(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      allocatedItemId: data.allocatedItemId.present
          ? data.allocatedItemId.value
          : this.allocatedItemId,
      allocatedItemType: data.allocatedItemType.present
          ? data.allocatedItemType.value
          : this.allocatedItemType,
      amount: data.amount.present ? data.amount.value : this.amount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Allocation(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('allocatedItemId: $allocatedItemId, ')
          ..write('allocatedItemType: $allocatedItemType, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, paymentId, allocatedItemId, allocatedItemType, amount, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Allocation &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.allocatedItemId == this.allocatedItemId &&
          other.allocatedItemType == this.allocatedItemType &&
          other.amount == this.amount &&
          other.isActive == this.isActive);
}

class AllocationsCompanion extends UpdateCompanion<Allocation> {
  final Value<int> id;
  final Value<int> paymentId;
  final Value<int> allocatedItemId;
  final Value<String> allocatedItemType;
  final Value<double> amount;
  final Value<int> isActive;
  const AllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.allocatedItemId = const Value.absent(),
    this.allocatedItemType = const Value.absent(),
    this.amount = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int paymentId,
    required int allocatedItemId,
    this.allocatedItemType = const Value.absent(),
    required double amount,
    this.isActive = const Value.absent(),
  })  : paymentId = Value(paymentId),
        allocatedItemId = Value(allocatedItemId),
        amount = Value(amount);
  static Insertable<Allocation> custom({
    Expression<int>? id,
    Expression<int>? paymentId,
    Expression<int>? allocatedItemId,
    Expression<String>? allocatedItemType,
    Expression<double>? amount,
    Expression<int>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (allocatedItemId != null) 'allocated_item_id': allocatedItemId,
      if (allocatedItemType != null) 'allocated_item_type': allocatedItemType,
      if (amount != null) 'amount': amount,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? paymentId,
      Value<int>? allocatedItemId,
      Value<String>? allocatedItemType,
      Value<double>? amount,
      Value<int>? isActive}) {
    return AllocationsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      allocatedItemId: allocatedItemId ?? this.allocatedItemId,
      allocatedItemType: allocatedItemType ?? this.allocatedItemType,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (allocatedItemId.present) {
      map['allocated_item_id'] = Variable<int>(allocatedItemId.value);
    }
    if (allocatedItemType.present) {
      map['allocated_item_type'] = Variable<String>(allocatedItemType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('allocatedItemId: $allocatedItemId, ')
          ..write('allocatedItemType: $allocatedItemType, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ProductPurchasesTable extends ProductPurchases
    with TableInfo<$ProductPurchasesTable, ProductPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _qtyPerUnitMeta =
      const VerificationMeta('qtyPerUnit');
  @override
  late final GeneratedColumn<double> qtyPerUnit = GeneratedColumn<double>(
      'qty_per_unit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _costPerUnitMeta =
      const VerificationMeta('costPerUnit');
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
      'cost_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingQuantityMeta =
      const VerificationMeta('remainingQuantity');
  @override
  late final GeneratedColumn<double> remainingQuantity =
      GeneratedColumn<double>('remaining_quantity', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        supplierId,
        date,
        quantity,
        qtyPerUnit,
        costPerUnit,
        totalCost,
        remainingQuantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<ProductPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('qty_per_unit')) {
      context.handle(
          _qtyPerUnitMeta,
          qtyPerUnit.isAcceptableOrUnknown(
              data['qty_per_unit']!, _qtyPerUnitMeta));
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
          _costPerUnitMeta,
          costPerUnit.isAcceptableOrUnknown(
              data['cost_per_unit']!, _costPerUnitMeta));
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('remaining_quantity')) {
      context.handle(
          _remainingQuantityMeta,
          remainingQuantity.isAcceptableOrUnknown(
              data['remaining_quantity']!, _remainingQuantityMeta));
    } else if (isInserting) {
      context.missing(_remainingQuantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPurchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      qtyPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}qty_per_unit'])!,
      costPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_unit'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      remainingQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_quantity'])!,
    );
  }

  @override
  $ProductPurchasesTable createAlias(String alias) {
    return $ProductPurchasesTable(attachedDatabase, alias);
  }
}

class ProductPurchase extends DataClass implements Insertable<ProductPurchase> {
  final int id;
  final int productId;
  final int? supplierId;
  final String date;
  final double quantity;
  final double qtyPerUnit;
  final double costPerUnit;
  final double totalCost;
  final double remainingQuantity;
  const ProductPurchase(
      {required this.id,
      required this.productId,
      this.supplierId,
      required this.date,
      required this.quantity,
      required this.qtyPerUnit,
      required this.costPerUnit,
      required this.totalCost,
      required this.remainingQuantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    map['date'] = Variable<String>(date);
    map['quantity'] = Variable<double>(quantity);
    map['qty_per_unit'] = Variable<double>(qtyPerUnit);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    map['total_cost'] = Variable<double>(totalCost);
    map['remaining_quantity'] = Variable<double>(remainingQuantity);
    return map;
  }

  ProductPurchasesCompanion toCompanion(bool nullToAbsent) {
    return ProductPurchasesCompanion(
      id: Value(id),
      productId: Value(productId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      date: Value(date),
      quantity: Value(quantity),
      qtyPerUnit: Value(qtyPerUnit),
      costPerUnit: Value(costPerUnit),
      totalCost: Value(totalCost),
      remainingQuantity: Value(remainingQuantity),
    );
  }

  factory ProductPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPurchase(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      date: serializer.fromJson<String>(json['date']),
      quantity: serializer.fromJson<double>(json['quantity']),
      qtyPerUnit: serializer.fromJson<double>(json['qtyPerUnit']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      remainingQuantity: serializer.fromJson<double>(json['remainingQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'supplierId': serializer.toJson<int?>(supplierId),
      'date': serializer.toJson<String>(date),
      'quantity': serializer.toJson<double>(quantity),
      'qtyPerUnit': serializer.toJson<double>(qtyPerUnit),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
      'totalCost': serializer.toJson<double>(totalCost),
      'remainingQuantity': serializer.toJson<double>(remainingQuantity),
    };
  }

  ProductPurchase copyWith(
          {int? id,
          int? productId,
          Value<int?> supplierId = const Value.absent(),
          String? date,
          double? quantity,
          double? qtyPerUnit,
          double? costPerUnit,
          double? totalCost,
          double? remainingQuantity}) =>
      ProductPurchase(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        qtyPerUnit: qtyPerUnit ?? this.qtyPerUnit,
        costPerUnit: costPerUnit ?? this.costPerUnit,
        totalCost: totalCost ?? this.totalCost,
        remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      );
  ProductPurchase copyWithCompanion(ProductPurchasesCompanion data) {
    return ProductPurchase(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      qtyPerUnit:
          data.qtyPerUnit.present ? data.qtyPerUnit.value : this.qtyPerUnit,
      costPerUnit:
          data.costPerUnit.present ? data.costPerUnit.value : this.costPerUnit,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      remainingQuantity: data.remainingQuantity.present
          ? data.remainingQuantity.value
          : this.remainingQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPurchase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('qtyPerUnit: $qtyPerUnit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalCost: $totalCost, ')
          ..write('remainingQuantity: $remainingQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, supplierId, date, quantity,
      qtyPerUnit, costPerUnit, totalCost, remainingQuantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPurchase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.supplierId == this.supplierId &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.qtyPerUnit == this.qtyPerUnit &&
          other.costPerUnit == this.costPerUnit &&
          other.totalCost == this.totalCost &&
          other.remainingQuantity == this.remainingQuantity);
}

class ProductPurchasesCompanion extends UpdateCompanion<ProductPurchase> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int?> supplierId;
  final Value<String> date;
  final Value<double> quantity;
  final Value<double> qtyPerUnit;
  final Value<double> costPerUnit;
  final Value<double> totalCost;
  final Value<double> remainingQuantity;
  const ProductPurchasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.qtyPerUnit = const Value.absent(),
    this.costPerUnit = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.remainingQuantity = const Value.absent(),
  });
  ProductPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    this.supplierId = const Value.absent(),
    required String date,
    required double quantity,
    this.qtyPerUnit = const Value.absent(),
    required double costPerUnit,
    required double totalCost,
    required double remainingQuantity,
  })  : productId = Value(productId),
        date = Value(date),
        quantity = Value(quantity),
        costPerUnit = Value(costPerUnit),
        totalCost = Value(totalCost),
        remainingQuantity = Value(remainingQuantity);
  static Insertable<ProductPurchase> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? supplierId,
    Expression<String>? date,
    Expression<double>? quantity,
    Expression<double>? qtyPerUnit,
    Expression<double>? costPerUnit,
    Expression<double>? totalCost,
    Expression<double>? remainingQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (qtyPerUnit != null) 'qty_per_unit': qtyPerUnit,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
      if (totalCost != null) 'total_cost': totalCost,
      if (remainingQuantity != null) 'remaining_quantity': remainingQuantity,
    });
  }

  ProductPurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<int?>? supplierId,
      Value<String>? date,
      Value<double>? quantity,
      Value<double>? qtyPerUnit,
      Value<double>? costPerUnit,
      Value<double>? totalCost,
      Value<double>? remainingQuantity}) {
    return ProductPurchasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      qtyPerUnit: qtyPerUnit ?? this.qtyPerUnit,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      totalCost: totalCost ?? this.totalCost,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (qtyPerUnit.present) {
      map['qty_per_unit'] = Variable<double>(qtyPerUnit.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (remainingQuantity.present) {
      map['remaining_quantity'] = Variable<double>(remainingQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('qtyPerUnit: $qtyPerUnit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalCost: $totalCost, ')
          ..write('remainingQuantity: $remainingQuantity')
          ..write(')'))
        .toString();
  }
}

class $StockAllocationsTable extends StockAllocations
    with TableInfo<$StockAllocationsTable, StockAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleItemIdMeta =
      const VerificationMeta('saleItemId');
  @override
  late final GeneratedColumn<int> saleItemId = GeneratedColumn<int>(
      'sale_item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPerUnitMeta =
      const VerificationMeta('costPerUnit');
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
      'cost_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleItemId, purchaseId, quantity, costPerUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<StockAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_item_id')) {
      context.handle(
          _saleItemIdMeta,
          saleItemId.isAcceptableOrUnknown(
              data['sale_item_id']!, _saleItemIdMeta));
    } else if (isInserting) {
      context.missing(_saleItemIdMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
          _costPerUnitMeta,
          costPerUnit.isAcceptableOrUnknown(
              data['cost_per_unit']!, _costPerUnitMeta));
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_item_id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      costPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_unit'])!,
    );
  }

  @override
  $StockAllocationsTable createAlias(String alias) {
    return $StockAllocationsTable(attachedDatabase, alias);
  }
}

class StockAllocation extends DataClass implements Insertable<StockAllocation> {
  final int id;
  final int saleItemId;
  final int purchaseId;
  final double quantity;
  final double costPerUnit;
  const StockAllocation(
      {required this.id,
      required this.saleItemId,
      required this.purchaseId,
      required this.quantity,
      required this.costPerUnit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_item_id'] = Variable<int>(saleItemId);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['quantity'] = Variable<double>(quantity);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    return map;
  }

  StockAllocationsCompanion toCompanion(bool nullToAbsent) {
    return StockAllocationsCompanion(
      id: Value(id),
      saleItemId: Value(saleItemId),
      purchaseId: Value(purchaseId),
      quantity: Value(quantity),
      costPerUnit: Value(costPerUnit),
    );
  }

  factory StockAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAllocation(
      id: serializer.fromJson<int>(json['id']),
      saleItemId: serializer.fromJson<int>(json['saleItemId']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleItemId': serializer.toJson<int>(saleItemId),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'quantity': serializer.toJson<double>(quantity),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
    };
  }

  StockAllocation copyWith(
          {int? id,
          int? saleItemId,
          int? purchaseId,
          double? quantity,
          double? costPerUnit}) =>
      StockAllocation(
        id: id ?? this.id,
        saleItemId: saleItemId ?? this.saleItemId,
        purchaseId: purchaseId ?? this.purchaseId,
        quantity: quantity ?? this.quantity,
        costPerUnit: costPerUnit ?? this.costPerUnit,
      );
  StockAllocation copyWithCompanion(StockAllocationsCompanion data) {
    return StockAllocation(
      id: data.id.present ? data.id.value : this.id,
      saleItemId:
          data.saleItemId.present ? data.saleItemId.value : this.saleItemId,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      costPerUnit:
          data.costPerUnit.present ? data.costPerUnit.value : this.costPerUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockAllocation(')
          ..write('id: $id, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnit: $costPerUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleItemId, purchaseId, quantity, costPerUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockAllocation &&
          other.id == this.id &&
          other.saleItemId == this.saleItemId &&
          other.purchaseId == this.purchaseId &&
          other.quantity == this.quantity &&
          other.costPerUnit == this.costPerUnit);
}

class StockAllocationsCompanion extends UpdateCompanion<StockAllocation> {
  final Value<int> id;
  final Value<int> saleItemId;
  final Value<int> purchaseId;
  final Value<double> quantity;
  final Value<double> costPerUnit;
  const StockAllocationsCompanion({
    this.id = const Value.absent(),
    this.saleItemId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.costPerUnit = const Value.absent(),
  });
  StockAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int saleItemId,
    required int purchaseId,
    required double quantity,
    required double costPerUnit,
  })  : saleItemId = Value(saleItemId),
        purchaseId = Value(purchaseId),
        quantity = Value(quantity),
        costPerUnit = Value(costPerUnit);
  static Insertable<StockAllocation> custom({
    Expression<int>? id,
    Expression<int>? saleItemId,
    Expression<int>? purchaseId,
    Expression<double>? quantity,
    Expression<double>? costPerUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleItemId != null) 'sale_item_id': saleItemId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (quantity != null) 'quantity': quantity,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
    });
  }

  StockAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleItemId,
      Value<int>? purchaseId,
      Value<double>? quantity,
      Value<double>? costPerUnit}) {
    return StockAllocationsCompanion(
      id: id ?? this.id,
      saleItemId: saleItemId ?? this.saleItemId,
      purchaseId: purchaseId ?? this.purchaseId,
      quantity: quantity ?? this.quantity,
      costPerUnit: costPerUnit ?? this.costPerUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleItemId.present) {
      map['sale_item_id'] = Variable<int>(saleItemId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnit: $costPerUnit')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        category,
        description,
        amount,
        paymentMethod,
        reference,
        personId,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String date;
  final String category;
  final String description;
  final double amount;
  final String? paymentMethod;
  final String? reference;
  final int? personId;
  final int isDeleted;
  const Expense(
      {required this.id,
      required this.date,
      required this.category,
      required this.description,
      required this.amount,
      this.paymentMethod,
      this.reference,
      this.personId,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      reference: serializer.fromJson<String?>(json['reference']),
      personId: serializer.fromJson<int?>(json['personId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'reference': serializer.toJson<String?>(reference),
      'personId': serializer.toJson<int?>(personId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Expense copyWith(
          {int? id,
          String? date,
          String? category,
          String? description,
          double? amount,
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          Value<int?> personId = const Value.absent(),
          int? isDeleted}) =>
      Expense(
        id: id ?? this.id,
        date: date ?? this.date,
        category: category ?? this.category,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        reference: reference.present ? reference.value : this.reference,
        personId: personId.present ? personId.value : this.personId,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      reference: data.reference.present ? data.reference.value : this.reference,
      personId: data.personId.present ? data.personId.value : this.personId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('personId: $personId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, category, description, amount,
      paymentMethod, reference, personId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.reference == this.reference &&
          other.personId == this.personId &&
          other.isDeleted == this.isDeleted);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> category;
  final Value<String> description;
  final Value<double> amount;
  final Value<String?> paymentMethod;
  final Value<String?> reference;
  final Value<int?> personId;
  final Value<int> isDeleted;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.personId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String category,
    required String description,
    required double amount,
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.personId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : date = Value(date),
        category = Value(category),
        description = Value(description),
        amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? category,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? paymentMethod,
    Expression<String>? reference,
    Expression<int>? personId,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (reference != null) 'reference': reference,
      if (personId != null) 'person_id': personId,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? category,
      Value<String>? description,
      Value<double>? amount,
      Value<String?>? paymentMethod,
      Value<String?>? reference,
      Value<int?>? personId,
      Value<int>? isDeleted}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      personId: personId ?? this.personId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('personId: $personId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('grey'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('receipt'));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<int> isDefault = GeneratedColumn<int>(
      'is_default', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, icon, isDefault, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_default'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final int id;
  final String name;
  final String color;
  final String icon;
  final int isDefault;
  final int isDeleted;
  const ExpenseCategory(
      {required this.id,
      required this.name,
      required this.color,
      required this.icon,
      required this.isDefault,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['icon'] = Variable<String>(icon);
    map['is_default'] = Variable<int>(isDefault);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: Value(icon),
      isDefault: Value(isDefault),
      isDeleted: Value(isDeleted),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String>(json['icon']),
      isDefault: serializer.fromJson<int>(json['isDefault']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String>(icon),
      'isDefault': serializer.toJson<int>(isDefault),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  ExpenseCategory copyWith(
          {int? id,
          String? name,
          String? color,
          String? icon,
          int? isDefault,
          int? isDeleted}) =>
      ExpenseCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        isDefault: isDefault ?? this.isDefault,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon, isDefault, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.isDefault == this.isDefault &&
          other.isDeleted == this.isDeleted);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String> icon;
  final Value<int> isDefault;
  final Value<int> isDeleted;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? isDefault,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (isDefault != null) 'is_default': isDefault,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? color,
      Value<String>? icon,
      Value<int>? isDefault,
      Value<int>? isDeleted}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<int>(isDefault.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $FinanceAgreementsTable extends FinanceAgreements
    with TableInfo<$FinanceAgreementsTable, FinanceAgreement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceAgreementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerAddressMeta =
      const VerificationMeta('customerAddress');
  @override
  late final GeneratedColumn<String> customerAddress = GeneratedColumn<String>(
      'customer_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _agreementDateMeta =
      const VerificationMeta('agreementDate');
  @override
  late final GeneratedColumn<String> agreementDate = GeneratedColumn<String>(
      'agreement_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loanAmountMeta =
      const VerificationMeta('loanAmount');
  @override
  late final GeneratedColumn<double> loanAmount = GeneratedColumn<double>(
      'loan_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentFrequencyMeta =
      const VerificationMeta('paymentFrequency');
  @override
  late final GeneratedColumn<String> paymentFrequency = GeneratedColumn<String>(
      'payment_frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Monthly'));
  static const VerificationMeta _paymentCountMeta =
      const VerificationMeta('paymentCount');
  @override
  late final GeneratedColumn<int> paymentCount = GeneratedColumn<int>(
      'payment_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _firstPaymentDateMeta =
      const VerificationMeta('firstPaymentDate');
  @override
  late final GeneratedColumn<String> firstPaymentDate = GeneratedColumn<String>(
      'first_payment_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentAmountMeta =
      const VerificationMeta('paymentAmount');
  @override
  late final GeneratedColumn<double> paymentAmount = GeneratedColumn<double>(
      'payment_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalInterestMeta =
      const VerificationMeta('totalInterest');
  @override
  late final GeneratedColumn<double> totalInterest = GeneratedColumn<double>(
      'total_interest', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalRepayableMeta =
      const VerificationMeta('totalRepayable');
  @override
  late final GeneratedColumn<double> totalRepayable = GeneratedColumn<double>(
      'total_repayable', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ACTIVE'));
  static const VerificationMeta _financeSourceMeta =
      const VerificationMeta('financeSource');
  @override
  late final GeneratedColumn<String> financeSource = GeneratedColumn<String>(
      'finance_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('standalone'));
  static const VerificationMeta _linkedPersonIdMeta =
      const VerificationMeta('linkedPersonId');
  @override
  late final GeneratedColumn<int> linkedPersonId = GeneratedColumn<int>(
      'linked_person_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sourceSalesAmountMeta =
      const VerificationMeta('sourceSalesAmount');
  @override
  late final GeneratedColumn<double> sourceSalesAmount =
      GeneratedColumn<double>('source_sales_amount', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _additionalAmountMeta =
      const VerificationMeta('additionalAmount');
  @override
  late final GeneratedColumn<double> additionalAmount = GeneratedColumn<double>(
      'additional_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _purposeNoteMeta =
      const VerificationMeta('purposeNote');
  @override
  late final GeneratedColumn<String> purposeNote = GeneratedColumn<String>(
      'purpose_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assetNoteMeta =
      const VerificationMeta('assetNote');
  @override
  late final GeneratedColumn<String> assetNote = GeneratedColumn<String>(
      'asset_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerName,
        customerAddress,
        agreementDate,
        loanAmount,
        interestRate,
        paymentFrequency,
        paymentCount,
        firstPaymentDate,
        paymentAmount,
        totalInterest,
        totalRepayable,
        status,
        financeSource,
        linkedPersonId,
        sourceSalesAmount,
        additionalAmount,
        purposeNote,
        assetNote,
        createdAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_agreements';
  @override
  VerificationContext validateIntegrity(Insertable<FinanceAgreement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_address')) {
      context.handle(
          _customerAddressMeta,
          customerAddress.isAcceptableOrUnknown(
              data['customer_address']!, _customerAddressMeta));
    }
    if (data.containsKey('agreement_date')) {
      context.handle(
          _agreementDateMeta,
          agreementDate.isAcceptableOrUnknown(
              data['agreement_date']!, _agreementDateMeta));
    } else if (isInserting) {
      context.missing(_agreementDateMeta);
    }
    if (data.containsKey('loan_amount')) {
      context.handle(
          _loanAmountMeta,
          loanAmount.isAcceptableOrUnknown(
              data['loan_amount']!, _loanAmountMeta));
    } else if (isInserting) {
      context.missing(_loanAmountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('payment_frequency')) {
      context.handle(
          _paymentFrequencyMeta,
          paymentFrequency.isAcceptableOrUnknown(
              data['payment_frequency']!, _paymentFrequencyMeta));
    }
    if (data.containsKey('payment_count')) {
      context.handle(
          _paymentCountMeta,
          paymentCount.isAcceptableOrUnknown(
              data['payment_count']!, _paymentCountMeta));
    } else if (isInserting) {
      context.missing(_paymentCountMeta);
    }
    if (data.containsKey('first_payment_date')) {
      context.handle(
          _firstPaymentDateMeta,
          firstPaymentDate.isAcceptableOrUnknown(
              data['first_payment_date']!, _firstPaymentDateMeta));
    } else if (isInserting) {
      context.missing(_firstPaymentDateMeta);
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
          _paymentAmountMeta,
          paymentAmount.isAcceptableOrUnknown(
              data['payment_amount']!, _paymentAmountMeta));
    } else if (isInserting) {
      context.missing(_paymentAmountMeta);
    }
    if (data.containsKey('total_interest')) {
      context.handle(
          _totalInterestMeta,
          totalInterest.isAcceptableOrUnknown(
              data['total_interest']!, _totalInterestMeta));
    } else if (isInserting) {
      context.missing(_totalInterestMeta);
    }
    if (data.containsKey('total_repayable')) {
      context.handle(
          _totalRepayableMeta,
          totalRepayable.isAcceptableOrUnknown(
              data['total_repayable']!, _totalRepayableMeta));
    } else if (isInserting) {
      context.missing(_totalRepayableMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('finance_source')) {
      context.handle(
          _financeSourceMeta,
          financeSource.isAcceptableOrUnknown(
              data['finance_source']!, _financeSourceMeta));
    }
    if (data.containsKey('linked_person_id')) {
      context.handle(
          _linkedPersonIdMeta,
          linkedPersonId.isAcceptableOrUnknown(
              data['linked_person_id']!, _linkedPersonIdMeta));
    }
    if (data.containsKey('source_sales_amount')) {
      context.handle(
          _sourceSalesAmountMeta,
          sourceSalesAmount.isAcceptableOrUnknown(
              data['source_sales_amount']!, _sourceSalesAmountMeta));
    }
    if (data.containsKey('additional_amount')) {
      context.handle(
          _additionalAmountMeta,
          additionalAmount.isAcceptableOrUnknown(
              data['additional_amount']!, _additionalAmountMeta));
    }
    if (data.containsKey('purpose_note')) {
      context.handle(
          _purposeNoteMeta,
          purposeNote.isAcceptableOrUnknown(
              data['purpose_note']!, _purposeNoteMeta));
    }
    if (data.containsKey('asset_note')) {
      context.handle(_assetNoteMeta,
          assetNote.isAcceptableOrUnknown(data['asset_note']!, _assetNoteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceAgreement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceAgreement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_address']),
      agreementDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agreement_date'])!,
      loanAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}loan_amount'])!,
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate'])!,
      paymentFrequency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_frequency'])!,
      paymentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_count'])!,
      firstPaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}first_payment_date'])!,
      paymentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}payment_amount'])!,
      totalInterest: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_interest'])!,
      totalRepayable: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_repayable'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      financeSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finance_source'])!,
      linkedPersonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}linked_person_id']),
      sourceSalesAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}source_sales_amount']),
      additionalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}additional_amount']),
      purposeNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose_note']),
      assetNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $FinanceAgreementsTable createAlias(String alias) {
    return $FinanceAgreementsTable(attachedDatabase, alias);
  }
}

class FinanceAgreement extends DataClass
    implements Insertable<FinanceAgreement> {
  final int id;

  /// Customer name (free text — not linked to People table)
  final String customerName;
  final String? customerAddress;

  /// Date the agreement was signed (ISO yyyy-MM-dd)
  final String agreementDate;

  /// Capital lent
  final double loanAmount;

  /// Annual interest rate as a percentage (e.g. 10.0 = 10%)
  final double interestRate;

  /// 'Weekly' or 'Monthly'
  final String paymentFrequency;

  /// Total number of scheduled payments
  final int paymentCount;

  /// Date of first payment (ISO yyyy-MM-dd)
  final String firstPaymentDate;

  /// Calculated at generation time — stored for display
  final double paymentAmount;
  final double totalInterest;
  final double totalRepayable;

  /// 'ACTIVE', 'COMPLETE', 'OVERDUE'
  final String status;

  /// 'standalone' | 'allocated' | 'hybrid'
  final String financeSource;

  /// FK to People.id — links agreement to a customer record (nullable for
  /// standalone agreements created outside the workspace)
  final int? linkedPersonId;

  /// For allocated/hybrid: the total of the source sales absorbed
  final double? sourceSalesAmount;

  /// For hybrid: the additional manual amount on top of source sales
  final double? additionalAmount;

  /// Free-text purpose / reason for the finance arrangement
  final String? purposeNote;

  /// Free-text security or supporting asset note
  final String? assetNote;
  final String createdAt;
  final int isDeleted;
  const FinanceAgreement(
      {required this.id,
      required this.customerName,
      this.customerAddress,
      required this.agreementDate,
      required this.loanAmount,
      required this.interestRate,
      required this.paymentFrequency,
      required this.paymentCount,
      required this.firstPaymentDate,
      required this.paymentAmount,
      required this.totalInterest,
      required this.totalRepayable,
      required this.status,
      required this.financeSource,
      this.linkedPersonId,
      this.sourceSalesAmount,
      this.additionalAmount,
      this.purposeNote,
      this.assetNote,
      required this.createdAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerAddress != null) {
      map['customer_address'] = Variable<String>(customerAddress);
    }
    map['agreement_date'] = Variable<String>(agreementDate);
    map['loan_amount'] = Variable<double>(loanAmount);
    map['interest_rate'] = Variable<double>(interestRate);
    map['payment_frequency'] = Variable<String>(paymentFrequency);
    map['payment_count'] = Variable<int>(paymentCount);
    map['first_payment_date'] = Variable<String>(firstPaymentDate);
    map['payment_amount'] = Variable<double>(paymentAmount);
    map['total_interest'] = Variable<double>(totalInterest);
    map['total_repayable'] = Variable<double>(totalRepayable);
    map['status'] = Variable<String>(status);
    map['finance_source'] = Variable<String>(financeSource);
    if (!nullToAbsent || linkedPersonId != null) {
      map['linked_person_id'] = Variable<int>(linkedPersonId);
    }
    if (!nullToAbsent || sourceSalesAmount != null) {
      map['source_sales_amount'] = Variable<double>(sourceSalesAmount);
    }
    if (!nullToAbsent || additionalAmount != null) {
      map['additional_amount'] = Variable<double>(additionalAmount);
    }
    if (!nullToAbsent || purposeNote != null) {
      map['purpose_note'] = Variable<String>(purposeNote);
    }
    if (!nullToAbsent || assetNote != null) {
      map['asset_note'] = Variable<String>(assetNote);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  FinanceAgreementsCompanion toCompanion(bool nullToAbsent) {
    return FinanceAgreementsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      customerAddress: customerAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAddress),
      agreementDate: Value(agreementDate),
      loanAmount: Value(loanAmount),
      interestRate: Value(interestRate),
      paymentFrequency: Value(paymentFrequency),
      paymentCount: Value(paymentCount),
      firstPaymentDate: Value(firstPaymentDate),
      paymentAmount: Value(paymentAmount),
      totalInterest: Value(totalInterest),
      totalRepayable: Value(totalRepayable),
      status: Value(status),
      financeSource: Value(financeSource),
      linkedPersonId: linkedPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedPersonId),
      sourceSalesAmount: sourceSalesAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceSalesAmount),
      additionalAmount: additionalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalAmount),
      purposeNote: purposeNote == null && nullToAbsent
          ? const Value.absent()
          : Value(purposeNote),
      assetNote: assetNote == null && nullToAbsent
          ? const Value.absent()
          : Value(assetNote),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory FinanceAgreement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceAgreement(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerAddress: serializer.fromJson<String?>(json['customerAddress']),
      agreementDate: serializer.fromJson<String>(json['agreementDate']),
      loanAmount: serializer.fromJson<double>(json['loanAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      paymentFrequency: serializer.fromJson<String>(json['paymentFrequency']),
      paymentCount: serializer.fromJson<int>(json['paymentCount']),
      firstPaymentDate: serializer.fromJson<String>(json['firstPaymentDate']),
      paymentAmount: serializer.fromJson<double>(json['paymentAmount']),
      totalInterest: serializer.fromJson<double>(json['totalInterest']),
      totalRepayable: serializer.fromJson<double>(json['totalRepayable']),
      status: serializer.fromJson<String>(json['status']),
      financeSource: serializer.fromJson<String>(json['financeSource']),
      linkedPersonId: serializer.fromJson<int?>(json['linkedPersonId']),
      sourceSalesAmount:
          serializer.fromJson<double?>(json['sourceSalesAmount']),
      additionalAmount: serializer.fromJson<double?>(json['additionalAmount']),
      purposeNote: serializer.fromJson<String?>(json['purposeNote']),
      assetNote: serializer.fromJson<String?>(json['assetNote']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'customerAddress': serializer.toJson<String?>(customerAddress),
      'agreementDate': serializer.toJson<String>(agreementDate),
      'loanAmount': serializer.toJson<double>(loanAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'paymentFrequency': serializer.toJson<String>(paymentFrequency),
      'paymentCount': serializer.toJson<int>(paymentCount),
      'firstPaymentDate': serializer.toJson<String>(firstPaymentDate),
      'paymentAmount': serializer.toJson<double>(paymentAmount),
      'totalInterest': serializer.toJson<double>(totalInterest),
      'totalRepayable': serializer.toJson<double>(totalRepayable),
      'status': serializer.toJson<String>(status),
      'financeSource': serializer.toJson<String>(financeSource),
      'linkedPersonId': serializer.toJson<int?>(linkedPersonId),
      'sourceSalesAmount': serializer.toJson<double?>(sourceSalesAmount),
      'additionalAmount': serializer.toJson<double?>(additionalAmount),
      'purposeNote': serializer.toJson<String?>(purposeNote),
      'assetNote': serializer.toJson<String?>(assetNote),
      'createdAt': serializer.toJson<String>(createdAt),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  FinanceAgreement copyWith(
          {int? id,
          String? customerName,
          Value<String?> customerAddress = const Value.absent(),
          String? agreementDate,
          double? loanAmount,
          double? interestRate,
          String? paymentFrequency,
          int? paymentCount,
          String? firstPaymentDate,
          double? paymentAmount,
          double? totalInterest,
          double? totalRepayable,
          String? status,
          String? financeSource,
          Value<int?> linkedPersonId = const Value.absent(),
          Value<double?> sourceSalesAmount = const Value.absent(),
          Value<double?> additionalAmount = const Value.absent(),
          Value<String?> purposeNote = const Value.absent(),
          Value<String?> assetNote = const Value.absent(),
          String? createdAt,
          int? isDeleted}) =>
      FinanceAgreement(
        id: id ?? this.id,
        customerName: customerName ?? this.customerName,
        customerAddress: customerAddress.present
            ? customerAddress.value
            : this.customerAddress,
        agreementDate: agreementDate ?? this.agreementDate,
        loanAmount: loanAmount ?? this.loanAmount,
        interestRate: interestRate ?? this.interestRate,
        paymentFrequency: paymentFrequency ?? this.paymentFrequency,
        paymentCount: paymentCount ?? this.paymentCount,
        firstPaymentDate: firstPaymentDate ?? this.firstPaymentDate,
        paymentAmount: paymentAmount ?? this.paymentAmount,
        totalInterest: totalInterest ?? this.totalInterest,
        totalRepayable: totalRepayable ?? this.totalRepayable,
        status: status ?? this.status,
        financeSource: financeSource ?? this.financeSource,
        linkedPersonId:
            linkedPersonId.present ? linkedPersonId.value : this.linkedPersonId,
        sourceSalesAmount: sourceSalesAmount.present
            ? sourceSalesAmount.value
            : this.sourceSalesAmount,
        additionalAmount: additionalAmount.present
            ? additionalAmount.value
            : this.additionalAmount,
        purposeNote: purposeNote.present ? purposeNote.value : this.purposeNote,
        assetNote: assetNote.present ? assetNote.value : this.assetNote,
        createdAt: createdAt ?? this.createdAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  FinanceAgreement copyWithCompanion(FinanceAgreementsCompanion data) {
    return FinanceAgreement(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerAddress: data.customerAddress.present
          ? data.customerAddress.value
          : this.customerAddress,
      agreementDate: data.agreementDate.present
          ? data.agreementDate.value
          : this.agreementDate,
      loanAmount:
          data.loanAmount.present ? data.loanAmount.value : this.loanAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      paymentFrequency: data.paymentFrequency.present
          ? data.paymentFrequency.value
          : this.paymentFrequency,
      paymentCount: data.paymentCount.present
          ? data.paymentCount.value
          : this.paymentCount,
      firstPaymentDate: data.firstPaymentDate.present
          ? data.firstPaymentDate.value
          : this.firstPaymentDate,
      paymentAmount: data.paymentAmount.present
          ? data.paymentAmount.value
          : this.paymentAmount,
      totalInterest: data.totalInterest.present
          ? data.totalInterest.value
          : this.totalInterest,
      totalRepayable: data.totalRepayable.present
          ? data.totalRepayable.value
          : this.totalRepayable,
      status: data.status.present ? data.status.value : this.status,
      financeSource: data.financeSource.present
          ? data.financeSource.value
          : this.financeSource,
      linkedPersonId: data.linkedPersonId.present
          ? data.linkedPersonId.value
          : this.linkedPersonId,
      sourceSalesAmount: data.sourceSalesAmount.present
          ? data.sourceSalesAmount.value
          : this.sourceSalesAmount,
      additionalAmount: data.additionalAmount.present
          ? data.additionalAmount.value
          : this.additionalAmount,
      purposeNote:
          data.purposeNote.present ? data.purposeNote.value : this.purposeNote,
      assetNote: data.assetNote.present ? data.assetNote.value : this.assetNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceAgreement(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('agreementDate: $agreementDate, ')
          ..write('loanAmount: $loanAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('paymentFrequency: $paymentFrequency, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('firstPaymentDate: $firstPaymentDate, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('totalInterest: $totalInterest, ')
          ..write('totalRepayable: $totalRepayable, ')
          ..write('status: $status, ')
          ..write('financeSource: $financeSource, ')
          ..write('linkedPersonId: $linkedPersonId, ')
          ..write('sourceSalesAmount: $sourceSalesAmount, ')
          ..write('additionalAmount: $additionalAmount, ')
          ..write('purposeNote: $purposeNote, ')
          ..write('assetNote: $assetNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        customerName,
        customerAddress,
        agreementDate,
        loanAmount,
        interestRate,
        paymentFrequency,
        paymentCount,
        firstPaymentDate,
        paymentAmount,
        totalInterest,
        totalRepayable,
        status,
        financeSource,
        linkedPersonId,
        sourceSalesAmount,
        additionalAmount,
        purposeNote,
        assetNote,
        createdAt,
        isDeleted
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceAgreement &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.customerAddress == this.customerAddress &&
          other.agreementDate == this.agreementDate &&
          other.loanAmount == this.loanAmount &&
          other.interestRate == this.interestRate &&
          other.paymentFrequency == this.paymentFrequency &&
          other.paymentCount == this.paymentCount &&
          other.firstPaymentDate == this.firstPaymentDate &&
          other.paymentAmount == this.paymentAmount &&
          other.totalInterest == this.totalInterest &&
          other.totalRepayable == this.totalRepayable &&
          other.status == this.status &&
          other.financeSource == this.financeSource &&
          other.linkedPersonId == this.linkedPersonId &&
          other.sourceSalesAmount == this.sourceSalesAmount &&
          other.additionalAmount == this.additionalAmount &&
          other.purposeNote == this.purposeNote &&
          other.assetNote == this.assetNote &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted);
}

class FinanceAgreementsCompanion extends UpdateCompanion<FinanceAgreement> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String?> customerAddress;
  final Value<String> agreementDate;
  final Value<double> loanAmount;
  final Value<double> interestRate;
  final Value<String> paymentFrequency;
  final Value<int> paymentCount;
  final Value<String> firstPaymentDate;
  final Value<double> paymentAmount;
  final Value<double> totalInterest;
  final Value<double> totalRepayable;
  final Value<String> status;
  final Value<String> financeSource;
  final Value<int?> linkedPersonId;
  final Value<double?> sourceSalesAmount;
  final Value<double?> additionalAmount;
  final Value<String?> purposeNote;
  final Value<String?> assetNote;
  final Value<String> createdAt;
  final Value<int> isDeleted;
  const FinanceAgreementsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.agreementDate = const Value.absent(),
    this.loanAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.paymentFrequency = const Value.absent(),
    this.paymentCount = const Value.absent(),
    this.firstPaymentDate = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.totalInterest = const Value.absent(),
    this.totalRepayable = const Value.absent(),
    this.status = const Value.absent(),
    this.financeSource = const Value.absent(),
    this.linkedPersonId = const Value.absent(),
    this.sourceSalesAmount = const Value.absent(),
    this.additionalAmount = const Value.absent(),
    this.purposeNote = const Value.absent(),
    this.assetNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  FinanceAgreementsCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    this.customerAddress = const Value.absent(),
    required String agreementDate,
    required double loanAmount,
    required double interestRate,
    this.paymentFrequency = const Value.absent(),
    required int paymentCount,
    required String firstPaymentDate,
    required double paymentAmount,
    required double totalInterest,
    required double totalRepayable,
    this.status = const Value.absent(),
    this.financeSource = const Value.absent(),
    this.linkedPersonId = const Value.absent(),
    this.sourceSalesAmount = const Value.absent(),
    this.additionalAmount = const Value.absent(),
    this.purposeNote = const Value.absent(),
    this.assetNote = const Value.absent(),
    required String createdAt,
    this.isDeleted = const Value.absent(),
  })  : customerName = Value(customerName),
        agreementDate = Value(agreementDate),
        loanAmount = Value(loanAmount),
        interestRate = Value(interestRate),
        paymentCount = Value(paymentCount),
        firstPaymentDate = Value(firstPaymentDate),
        paymentAmount = Value(paymentAmount),
        totalInterest = Value(totalInterest),
        totalRepayable = Value(totalRepayable),
        createdAt = Value(createdAt);
  static Insertable<FinanceAgreement> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? customerAddress,
    Expression<String>? agreementDate,
    Expression<double>? loanAmount,
    Expression<double>? interestRate,
    Expression<String>? paymentFrequency,
    Expression<int>? paymentCount,
    Expression<String>? firstPaymentDate,
    Expression<double>? paymentAmount,
    Expression<double>? totalInterest,
    Expression<double>? totalRepayable,
    Expression<String>? status,
    Expression<String>? financeSource,
    Expression<int>? linkedPersonId,
    Expression<double>? sourceSalesAmount,
    Expression<double>? additionalAmount,
    Expression<String>? purposeNote,
    Expression<String>? assetNote,
    Expression<String>? createdAt,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (customerAddress != null) 'customer_address': customerAddress,
      if (agreementDate != null) 'agreement_date': agreementDate,
      if (loanAmount != null) 'loan_amount': loanAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (paymentFrequency != null) 'payment_frequency': paymentFrequency,
      if (paymentCount != null) 'payment_count': paymentCount,
      if (firstPaymentDate != null) 'first_payment_date': firstPaymentDate,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
      if (totalInterest != null) 'total_interest': totalInterest,
      if (totalRepayable != null) 'total_repayable': totalRepayable,
      if (status != null) 'status': status,
      if (financeSource != null) 'finance_source': financeSource,
      if (linkedPersonId != null) 'linked_person_id': linkedPersonId,
      if (sourceSalesAmount != null) 'source_sales_amount': sourceSalesAmount,
      if (additionalAmount != null) 'additional_amount': additionalAmount,
      if (purposeNote != null) 'purpose_note': purposeNote,
      if (assetNote != null) 'asset_note': assetNote,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  FinanceAgreementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? customerName,
      Value<String?>? customerAddress,
      Value<String>? agreementDate,
      Value<double>? loanAmount,
      Value<double>? interestRate,
      Value<String>? paymentFrequency,
      Value<int>? paymentCount,
      Value<String>? firstPaymentDate,
      Value<double>? paymentAmount,
      Value<double>? totalInterest,
      Value<double>? totalRepayable,
      Value<String>? status,
      Value<String>? financeSource,
      Value<int?>? linkedPersonId,
      Value<double?>? sourceSalesAmount,
      Value<double?>? additionalAmount,
      Value<String?>? purposeNote,
      Value<String?>? assetNote,
      Value<String>? createdAt,
      Value<int>? isDeleted}) {
    return FinanceAgreementsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      agreementDate: agreementDate ?? this.agreementDate,
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      paymentCount: paymentCount ?? this.paymentCount,
      firstPaymentDate: firstPaymentDate ?? this.firstPaymentDate,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      totalInterest: totalInterest ?? this.totalInterest,
      totalRepayable: totalRepayable ?? this.totalRepayable,
      status: status ?? this.status,
      financeSource: financeSource ?? this.financeSource,
      linkedPersonId: linkedPersonId ?? this.linkedPersonId,
      sourceSalesAmount: sourceSalesAmount ?? this.sourceSalesAmount,
      additionalAmount: additionalAmount ?? this.additionalAmount,
      purposeNote: purposeNote ?? this.purposeNote,
      assetNote: assetNote ?? this.assetNote,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerAddress.present) {
      map['customer_address'] = Variable<String>(customerAddress.value);
    }
    if (agreementDate.present) {
      map['agreement_date'] = Variable<String>(agreementDate.value);
    }
    if (loanAmount.present) {
      map['loan_amount'] = Variable<double>(loanAmount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (paymentFrequency.present) {
      map['payment_frequency'] = Variable<String>(paymentFrequency.value);
    }
    if (paymentCount.present) {
      map['payment_count'] = Variable<int>(paymentCount.value);
    }
    if (firstPaymentDate.present) {
      map['first_payment_date'] = Variable<String>(firstPaymentDate.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<double>(paymentAmount.value);
    }
    if (totalInterest.present) {
      map['total_interest'] = Variable<double>(totalInterest.value);
    }
    if (totalRepayable.present) {
      map['total_repayable'] = Variable<double>(totalRepayable.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (financeSource.present) {
      map['finance_source'] = Variable<String>(financeSource.value);
    }
    if (linkedPersonId.present) {
      map['linked_person_id'] = Variable<int>(linkedPersonId.value);
    }
    if (sourceSalesAmount.present) {
      map['source_sales_amount'] = Variable<double>(sourceSalesAmount.value);
    }
    if (additionalAmount.present) {
      map['additional_amount'] = Variable<double>(additionalAmount.value);
    }
    if (purposeNote.present) {
      map['purpose_note'] = Variable<String>(purposeNote.value);
    }
    if (assetNote.present) {
      map['asset_note'] = Variable<String>(assetNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceAgreementsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('agreementDate: $agreementDate, ')
          ..write('loanAmount: $loanAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('paymentFrequency: $paymentFrequency, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('firstPaymentDate: $firstPaymentDate, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('totalInterest: $totalInterest, ')
          ..write('totalRepayable: $totalRepayable, ')
          ..write('status: $status, ')
          ..write('financeSource: $financeSource, ')
          ..write('linkedPersonId: $linkedPersonId, ')
          ..write('sourceSalesAmount: $sourceSalesAmount, ')
          ..write('additionalAmount: $additionalAmount, ')
          ..write('purposeNote: $purposeNote, ')
          ..write('assetNote: $assetNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $FinancePaymentsTable extends FinancePayments
    with TableInfo<$FinancePaymentsTable, FinancePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _agreementIdMeta =
      const VerificationMeta('agreementId');
  @override
  late final GeneratedColumn<int> agreementId = GeneratedColumn<int>(
      'agreement_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentNoMeta =
      const VerificationMeta('paymentNo');
  @override
  late final GeneratedColumn<int> paymentNo = GeneratedColumn<int>(
      'payment_no', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentAmountMeta =
      const VerificationMeta('paymentAmount');
  @override
  late final GeneratedColumn<double> paymentAmount = GeneratedColumn<double>(
      'payment_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _interestAmountMeta =
      const VerificationMeta('interestAmount');
  @override
  late final GeneratedColumn<double> interestAmount = GeneratedColumn<double>(
      'interest_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _capitalAmountMeta =
      const VerificationMeta('capitalAmount');
  @override
  late final GeneratedColumn<double> capitalAmount = GeneratedColumn<double>(
      'capital_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closingBalanceMeta =
      const VerificationMeta('closingBalance');
  @override
  late final GeneratedColumn<double> closingBalance = GeneratedColumn<double>(
      'closing_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<int> paid = GeneratedColumn<int>(
      'paid', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paidDateMeta =
      const VerificationMeta('paidDate');
  @override
  late final GeneratedColumn<String> paidDate = GeneratedColumn<String>(
      'paid_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rowTypeMeta =
      const VerificationMeta('rowType');
  @override
  late final GeneratedColumn<String> rowType = GeneratedColumn<String>(
      'row_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SCHEDULED'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        agreementId,
        paymentNo,
        dueDate,
        openingBalance,
        paymentAmount,
        interestAmount,
        capitalAmount,
        closingBalance,
        paid,
        paidDate,
        rowType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_payments';
  @override
  VerificationContext validateIntegrity(Insertable<FinancePayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('agreement_id')) {
      context.handle(
          _agreementIdMeta,
          agreementId.isAcceptableOrUnknown(
              data['agreement_id']!, _agreementIdMeta));
    } else if (isInserting) {
      context.missing(_agreementIdMeta);
    }
    if (data.containsKey('payment_no')) {
      context.handle(_paymentNoMeta,
          paymentNo.isAcceptableOrUnknown(data['payment_no']!, _paymentNoMeta));
    } else if (isInserting) {
      context.missing(_paymentNoMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    } else if (isInserting) {
      context.missing(_openingBalanceMeta);
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
          _paymentAmountMeta,
          paymentAmount.isAcceptableOrUnknown(
              data['payment_amount']!, _paymentAmountMeta));
    } else if (isInserting) {
      context.missing(_paymentAmountMeta);
    }
    if (data.containsKey('interest_amount')) {
      context.handle(
          _interestAmountMeta,
          interestAmount.isAcceptableOrUnknown(
              data['interest_amount']!, _interestAmountMeta));
    } else if (isInserting) {
      context.missing(_interestAmountMeta);
    }
    if (data.containsKey('capital_amount')) {
      context.handle(
          _capitalAmountMeta,
          capitalAmount.isAcceptableOrUnknown(
              data['capital_amount']!, _capitalAmountMeta));
    } else if (isInserting) {
      context.missing(_capitalAmountMeta);
    }
    if (data.containsKey('closing_balance')) {
      context.handle(
          _closingBalanceMeta,
          closingBalance.isAcceptableOrUnknown(
              data['closing_balance']!, _closingBalanceMeta));
    } else if (isInserting) {
      context.missing(_closingBalanceMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
          _paidMeta, paid.isAcceptableOrUnknown(data['paid']!, _paidMeta));
    }
    if (data.containsKey('paid_date')) {
      context.handle(_paidDateMeta,
          paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta));
    }
    if (data.containsKey('row_type')) {
      context.handle(_rowTypeMeta,
          rowType.isAcceptableOrUnknown(data['row_type']!, _rowTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancePayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      agreementId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agreement_id'])!,
      paymentNo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_no'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date'])!,
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      paymentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}payment_amount'])!,
      interestAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}interest_amount'])!,
      capitalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}capital_amount'])!,
      closingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}closing_balance'])!,
      paid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid'])!,
      paidDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paid_date']),
      rowType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}row_type'])!,
    );
  }

  @override
  $FinancePaymentsTable createAlias(String alias) {
    return $FinancePaymentsTable(attachedDatabase, alias);
  }
}

class FinancePayment extends DataClass implements Insertable<FinancePayment> {
  final int id;
  final int agreementId;
  final int paymentNo;

  /// ISO yyyy-MM-dd
  final String dueDate;
  final double openingBalance;
  final double paymentAmount;
  final double interestAmount;
  final double capitalAmount;
  final double closingBalance;

  /// 0 = pending, 1 = paid
  final int paid;

  /// ISO yyyy-MM-dd, nullable
  final String? paidDate;

  /// 'SCHEDULED' or 'SETTLEMENT' (early settlement row)
  final String rowType;
  const FinancePayment(
      {required this.id,
      required this.agreementId,
      required this.paymentNo,
      required this.dueDate,
      required this.openingBalance,
      required this.paymentAmount,
      required this.interestAmount,
      required this.capitalAmount,
      required this.closingBalance,
      required this.paid,
      this.paidDate,
      required this.rowType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['agreement_id'] = Variable<int>(agreementId);
    map['payment_no'] = Variable<int>(paymentNo);
    map['due_date'] = Variable<String>(dueDate);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['payment_amount'] = Variable<double>(paymentAmount);
    map['interest_amount'] = Variable<double>(interestAmount);
    map['capital_amount'] = Variable<double>(capitalAmount);
    map['closing_balance'] = Variable<double>(closingBalance);
    map['paid'] = Variable<int>(paid);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<String>(paidDate);
    }
    map['row_type'] = Variable<String>(rowType);
    return map;
  }

  FinancePaymentsCompanion toCompanion(bool nullToAbsent) {
    return FinancePaymentsCompanion(
      id: Value(id),
      agreementId: Value(agreementId),
      paymentNo: Value(paymentNo),
      dueDate: Value(dueDate),
      openingBalance: Value(openingBalance),
      paymentAmount: Value(paymentAmount),
      interestAmount: Value(interestAmount),
      capitalAmount: Value(capitalAmount),
      closingBalance: Value(closingBalance),
      paid: Value(paid),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      rowType: Value(rowType),
    );
  }

  factory FinancePayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancePayment(
      id: serializer.fromJson<int>(json['id']),
      agreementId: serializer.fromJson<int>(json['agreementId']),
      paymentNo: serializer.fromJson<int>(json['paymentNo']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      paymentAmount: serializer.fromJson<double>(json['paymentAmount']),
      interestAmount: serializer.fromJson<double>(json['interestAmount']),
      capitalAmount: serializer.fromJson<double>(json['capitalAmount']),
      closingBalance: serializer.fromJson<double>(json['closingBalance']),
      paid: serializer.fromJson<int>(json['paid']),
      paidDate: serializer.fromJson<String?>(json['paidDate']),
      rowType: serializer.fromJson<String>(json['rowType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'agreementId': serializer.toJson<int>(agreementId),
      'paymentNo': serializer.toJson<int>(paymentNo),
      'dueDate': serializer.toJson<String>(dueDate),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'paymentAmount': serializer.toJson<double>(paymentAmount),
      'interestAmount': serializer.toJson<double>(interestAmount),
      'capitalAmount': serializer.toJson<double>(capitalAmount),
      'closingBalance': serializer.toJson<double>(closingBalance),
      'paid': serializer.toJson<int>(paid),
      'paidDate': serializer.toJson<String?>(paidDate),
      'rowType': serializer.toJson<String>(rowType),
    };
  }

  FinancePayment copyWith(
          {int? id,
          int? agreementId,
          int? paymentNo,
          String? dueDate,
          double? openingBalance,
          double? paymentAmount,
          double? interestAmount,
          double? capitalAmount,
          double? closingBalance,
          int? paid,
          Value<String?> paidDate = const Value.absent(),
          String? rowType}) =>
      FinancePayment(
        id: id ?? this.id,
        agreementId: agreementId ?? this.agreementId,
        paymentNo: paymentNo ?? this.paymentNo,
        dueDate: dueDate ?? this.dueDate,
        openingBalance: openingBalance ?? this.openingBalance,
        paymentAmount: paymentAmount ?? this.paymentAmount,
        interestAmount: interestAmount ?? this.interestAmount,
        capitalAmount: capitalAmount ?? this.capitalAmount,
        closingBalance: closingBalance ?? this.closingBalance,
        paid: paid ?? this.paid,
        paidDate: paidDate.present ? paidDate.value : this.paidDate,
        rowType: rowType ?? this.rowType,
      );
  FinancePayment copyWithCompanion(FinancePaymentsCompanion data) {
    return FinancePayment(
      id: data.id.present ? data.id.value : this.id,
      agreementId:
          data.agreementId.present ? data.agreementId.value : this.agreementId,
      paymentNo: data.paymentNo.present ? data.paymentNo.value : this.paymentNo,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      paymentAmount: data.paymentAmount.present
          ? data.paymentAmount.value
          : this.paymentAmount,
      interestAmount: data.interestAmount.present
          ? data.interestAmount.value
          : this.interestAmount,
      capitalAmount: data.capitalAmount.present
          ? data.capitalAmount.value
          : this.capitalAmount,
      closingBalance: data.closingBalance.present
          ? data.closingBalance.value
          : this.closingBalance,
      paid: data.paid.present ? data.paid.value : this.paid,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      rowType: data.rowType.present ? data.rowType.value : this.rowType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancePayment(')
          ..write('id: $id, ')
          ..write('agreementId: $agreementId, ')
          ..write('paymentNo: $paymentNo, ')
          ..write('dueDate: $dueDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('interestAmount: $interestAmount, ')
          ..write('capitalAmount: $capitalAmount, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('rowType: $rowType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      agreementId,
      paymentNo,
      dueDate,
      openingBalance,
      paymentAmount,
      interestAmount,
      capitalAmount,
      closingBalance,
      paid,
      paidDate,
      rowType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancePayment &&
          other.id == this.id &&
          other.agreementId == this.agreementId &&
          other.paymentNo == this.paymentNo &&
          other.dueDate == this.dueDate &&
          other.openingBalance == this.openingBalance &&
          other.paymentAmount == this.paymentAmount &&
          other.interestAmount == this.interestAmount &&
          other.capitalAmount == this.capitalAmount &&
          other.closingBalance == this.closingBalance &&
          other.paid == this.paid &&
          other.paidDate == this.paidDate &&
          other.rowType == this.rowType);
}

class FinancePaymentsCompanion extends UpdateCompanion<FinancePayment> {
  final Value<int> id;
  final Value<int> agreementId;
  final Value<int> paymentNo;
  final Value<String> dueDate;
  final Value<double> openingBalance;
  final Value<double> paymentAmount;
  final Value<double> interestAmount;
  final Value<double> capitalAmount;
  final Value<double> closingBalance;
  final Value<int> paid;
  final Value<String?> paidDate;
  final Value<String> rowType;
  const FinancePaymentsCompanion({
    this.id = const Value.absent(),
    this.agreementId = const Value.absent(),
    this.paymentNo = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.interestAmount = const Value.absent(),
    this.capitalAmount = const Value.absent(),
    this.closingBalance = const Value.absent(),
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowType = const Value.absent(),
  });
  FinancePaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int agreementId,
    required int paymentNo,
    required String dueDate,
    required double openingBalance,
    required double paymentAmount,
    required double interestAmount,
    required double capitalAmount,
    required double closingBalance,
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowType = const Value.absent(),
  })  : agreementId = Value(agreementId),
        paymentNo = Value(paymentNo),
        dueDate = Value(dueDate),
        openingBalance = Value(openingBalance),
        paymentAmount = Value(paymentAmount),
        interestAmount = Value(interestAmount),
        capitalAmount = Value(capitalAmount),
        closingBalance = Value(closingBalance);
  static Insertable<FinancePayment> custom({
    Expression<int>? id,
    Expression<int>? agreementId,
    Expression<int>? paymentNo,
    Expression<String>? dueDate,
    Expression<double>? openingBalance,
    Expression<double>? paymentAmount,
    Expression<double>? interestAmount,
    Expression<double>? capitalAmount,
    Expression<double>? closingBalance,
    Expression<int>? paid,
    Expression<String>? paidDate,
    Expression<String>? rowType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (agreementId != null) 'agreement_id': agreementId,
      if (paymentNo != null) 'payment_no': paymentNo,
      if (dueDate != null) 'due_date': dueDate,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
      if (interestAmount != null) 'interest_amount': interestAmount,
      if (capitalAmount != null) 'capital_amount': capitalAmount,
      if (closingBalance != null) 'closing_balance': closingBalance,
      if (paid != null) 'paid': paid,
      if (paidDate != null) 'paid_date': paidDate,
      if (rowType != null) 'row_type': rowType,
    });
  }

  FinancePaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? agreementId,
      Value<int>? paymentNo,
      Value<String>? dueDate,
      Value<double>? openingBalance,
      Value<double>? paymentAmount,
      Value<double>? interestAmount,
      Value<double>? capitalAmount,
      Value<double>? closingBalance,
      Value<int>? paid,
      Value<String?>? paidDate,
      Value<String>? rowType}) {
    return FinancePaymentsCompanion(
      id: id ?? this.id,
      agreementId: agreementId ?? this.agreementId,
      paymentNo: paymentNo ?? this.paymentNo,
      dueDate: dueDate ?? this.dueDate,
      openingBalance: openingBalance ?? this.openingBalance,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      interestAmount: interestAmount ?? this.interestAmount,
      capitalAmount: capitalAmount ?? this.capitalAmount,
      closingBalance: closingBalance ?? this.closingBalance,
      paid: paid ?? this.paid,
      paidDate: paidDate ?? this.paidDate,
      rowType: rowType ?? this.rowType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (agreementId.present) {
      map['agreement_id'] = Variable<int>(agreementId.value);
    }
    if (paymentNo.present) {
      map['payment_no'] = Variable<int>(paymentNo.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<double>(paymentAmount.value);
    }
    if (interestAmount.present) {
      map['interest_amount'] = Variable<double>(interestAmount.value);
    }
    if (capitalAmount.present) {
      map['capital_amount'] = Variable<double>(capitalAmount.value);
    }
    if (closingBalance.present) {
      map['closing_balance'] = Variable<double>(closingBalance.value);
    }
    if (paid.present) {
      map['paid'] = Variable<int>(paid.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<String>(paidDate.value);
    }
    if (rowType.present) {
      map['row_type'] = Variable<String>(rowType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('agreementId: $agreementId, ')
          ..write('paymentNo: $paymentNo, ')
          ..write('dueDate: $dueDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('interestAmount: $interestAmount, ')
          ..write('capitalAmount: $capitalAmount, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('rowType: $rowType')
          ..write(')'))
        .toString();
  }
}

class $FinanceSaleLinksTable extends FinanceSaleLinks
    with TableInfo<$FinanceSaleLinksTable, FinanceSaleLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceSaleLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _agreementIdMeta =
      const VerificationMeta('agreementId');
  @override
  late final GeneratedColumn<int> agreementId = GeneratedColumn<int>(
      'agreement_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, agreementId, saleId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_sale_links';
  @override
  VerificationContext validateIntegrity(Insertable<FinanceSaleLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('agreement_id')) {
      context.handle(
          _agreementIdMeta,
          agreementId.isAcceptableOrUnknown(
              data['agreement_id']!, _agreementIdMeta));
    } else if (isInserting) {
      context.missing(_agreementIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceSaleLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceSaleLink(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      agreementId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agreement_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
    );
  }

  @override
  $FinanceSaleLinksTable createAlias(String alias) {
    return $FinanceSaleLinksTable(attachedDatabase, alias);
  }
}

class FinanceSaleLink extends DataClass implements Insertable<FinanceSaleLink> {
  final int id;
  final int agreementId;
  final int saleId;
  const FinanceSaleLink(
      {required this.id, required this.agreementId, required this.saleId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['agreement_id'] = Variable<int>(agreementId);
    map['sale_id'] = Variable<int>(saleId);
    return map;
  }

  FinanceSaleLinksCompanion toCompanion(bool nullToAbsent) {
    return FinanceSaleLinksCompanion(
      id: Value(id),
      agreementId: Value(agreementId),
      saleId: Value(saleId),
    );
  }

  factory FinanceSaleLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceSaleLink(
      id: serializer.fromJson<int>(json['id']),
      agreementId: serializer.fromJson<int>(json['agreementId']),
      saleId: serializer.fromJson<int>(json['saleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'agreementId': serializer.toJson<int>(agreementId),
      'saleId': serializer.toJson<int>(saleId),
    };
  }

  FinanceSaleLink copyWith({int? id, int? agreementId, int? saleId}) =>
      FinanceSaleLink(
        id: id ?? this.id,
        agreementId: agreementId ?? this.agreementId,
        saleId: saleId ?? this.saleId,
      );
  FinanceSaleLink copyWithCompanion(FinanceSaleLinksCompanion data) {
    return FinanceSaleLink(
      id: data.id.present ? data.id.value : this.id,
      agreementId:
          data.agreementId.present ? data.agreementId.value : this.agreementId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceSaleLink(')
          ..write('id: $id, ')
          ..write('agreementId: $agreementId, ')
          ..write('saleId: $saleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, agreementId, saleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceSaleLink &&
          other.id == this.id &&
          other.agreementId == this.agreementId &&
          other.saleId == this.saleId);
}

class FinanceSaleLinksCompanion extends UpdateCompanion<FinanceSaleLink> {
  final Value<int> id;
  final Value<int> agreementId;
  final Value<int> saleId;
  const FinanceSaleLinksCompanion({
    this.id = const Value.absent(),
    this.agreementId = const Value.absent(),
    this.saleId = const Value.absent(),
  });
  FinanceSaleLinksCompanion.insert({
    this.id = const Value.absent(),
    required int agreementId,
    required int saleId,
  })  : agreementId = Value(agreementId),
        saleId = Value(saleId);
  static Insertable<FinanceSaleLink> custom({
    Expression<int>? id,
    Expression<int>? agreementId,
    Expression<int>? saleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (agreementId != null) 'agreement_id': agreementId,
      if (saleId != null) 'sale_id': saleId,
    });
  }

  FinanceSaleLinksCompanion copyWith(
      {Value<int>? id, Value<int>? agreementId, Value<int>? saleId}) {
    return FinanceSaleLinksCompanion(
      id: id ?? this.id,
      agreementId: agreementId ?? this.agreementId,
      saleId: saleId ?? this.saleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (agreementId.present) {
      map['agreement_id'] = Variable<int>(agreementId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceSaleLinksCompanion(')
          ..write('id: $id, ')
          ..write('agreementId: $agreementId, ')
          ..write('saleId: $saleId')
          ..write(')'))
        .toString();
  }
}

class $SupplierInvoicesTable extends SupplierInvoices
    with TableInfo<$SupplierInvoicesTable, SupplierInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UNPAID'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierId,
        invoiceNumber,
        date,
        dueDate,
        total,
        status,
        notes,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_invoices';
  @override
  VerificationContext validateIntegrity(Insertable<SupplierInvoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierInvoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $SupplierInvoicesTable createAlias(String alias) {
    return $SupplierInvoicesTable(attachedDatabase, alias);
  }
}

class SupplierInvoice extends DataClass implements Insertable<SupplierInvoice> {
  final int id;
  final int supplierId;
  final String invoiceNumber;
  final String date;
  final String? dueDate;
  final double total;
  final String status;
  final String? notes;
  final int isDeleted;
  const SupplierInvoice(
      {required this.id,
      required this.supplierId,
      required this.invoiceNumber,
      required this.date,
      this.dueDate,
      required this.total,
      required this.status,
      this.notes,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['total'] = Variable<double>(total);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  SupplierInvoicesCompanion toCompanion(bool nullToAbsent) {
    return SupplierInvoicesCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      invoiceNumber: Value(invoiceNumber),
      date: Value(date),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      total: Value(total),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isDeleted: Value(isDeleted),
    );
  }

  factory SupplierInvoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierInvoice(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      date: serializer.fromJson<String>(json['date']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      total: serializer.fromJson<double>(json['total']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'date': serializer.toJson<String>(date),
      'dueDate': serializer.toJson<String?>(dueDate),
      'total': serializer.toJson<double>(total),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  SupplierInvoice copyWith(
          {int? id,
          int? supplierId,
          String? invoiceNumber,
          String? date,
          Value<String?> dueDate = const Value.absent(),
          double? total,
          String? status,
          Value<String?> notes = const Value.absent(),
          int? isDeleted}) =>
      SupplierInvoice(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        date: date ?? this.date,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        total: total ?? this.total,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  SupplierInvoice copyWithCompanion(SupplierInvoicesCompanion data) {
    return SupplierInvoice(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      date: data.date.present ? data.date.value : this.date,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierInvoice(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, supplierId, invoiceNumber, date, dueDate,
      total, status, notes, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierInvoice &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.date == this.date &&
          other.dueDate == this.dueDate &&
          other.total == this.total &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isDeleted == this.isDeleted);
}

class SupplierInvoicesCompanion extends UpdateCompanion<SupplierInvoice> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<String> invoiceNumber;
  final Value<String> date;
  final Value<String?> dueDate;
  final Value<double> total;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> isDeleted;
  const SupplierInvoicesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  SupplierInvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required String invoiceNumber,
    required String date,
    this.dueDate = const Value.absent(),
    required double total,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : supplierId = Value(supplierId),
        invoiceNumber = Value(invoiceNumber),
        date = Value(date),
        total = Value(total);
  static Insertable<SupplierInvoice> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? invoiceNumber,
    Expression<String>? date,
    Expression<String>? dueDate,
    Expression<double>? total,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (date != null) 'date': date,
      if (dueDate != null) 'due_date': dueDate,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  SupplierInvoicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? supplierId,
      Value<String>? invoiceNumber,
      Value<String>? date,
      Value<String?>? dueDate,
      Value<double>? total,
      Value<String>? status,
      Value<String?>? notes,
      Value<int>? isDeleted}) {
    return SupplierInvoicesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      total: total ?? this.total,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SupplierInvoiceItemsTable extends SupplierInvoiceItems
    with TableInfo<$SupplierInvoiceItemsTable, SupplierInvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierInvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _unitCostMeta =
      const VerificationMeta('unitCost');
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
      'unit_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        description,
        category,
        productId,
        quantity,
        unitCost,
        total
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_invoice_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<SupplierInvoiceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit_cost')) {
      context.handle(_unitCostMeta,
          unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta));
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierInvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierInvoiceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unitCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_cost'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
    );
  }

  @override
  $SupplierInvoiceItemsTable createAlias(String alias) {
    return $SupplierInvoiceItemsTable(attachedDatabase, alias);
  }
}

class SupplierInvoiceItem extends DataClass
    implements Insertable<SupplierInvoiceItem> {
  final int id;
  final int invoiceId;
  final String description;
  final String? category;
  final int? productId;
  final double quantity;
  final double unitCost;
  final double total;
  const SupplierInvoiceItem(
      {required this.id,
      required this.invoiceId,
      required this.description,
      this.category,
      this.productId,
      required this.quantity,
      required this.unitCost,
      required this.total});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit_cost'] = Variable<double>(unitCost);
    map['total'] = Variable<double>(total);
    return map;
  }

  SupplierInvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return SupplierInvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      description: Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      quantity: Value(quantity),
      unitCost: Value(unitCost),
      total: Value(total),
    );
  }

  factory SupplierInvoiceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierInvoiceItem(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      productId: serializer.fromJson<int?>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String?>(category),
      'productId': serializer.toJson<int?>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitCost': serializer.toJson<double>(unitCost),
      'total': serializer.toJson<double>(total),
    };
  }

  SupplierInvoiceItem copyWith(
          {int? id,
          int? invoiceId,
          String? description,
          Value<String?> category = const Value.absent(),
          Value<int?> productId = const Value.absent(),
          double? quantity,
          double? unitCost,
          double? total}) =>
      SupplierInvoiceItem(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        description: description ?? this.description,
        category: category.present ? category.value : this.category,
        productId: productId.present ? productId.value : this.productId,
        quantity: quantity ?? this.quantity,
        unitCost: unitCost ?? this.unitCost,
        total: total ?? this.total,
      );
  SupplierInvoiceItem copyWithCompanion(SupplierInvoiceItemsCompanion data) {
    return SupplierInvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierInvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoiceId, description, category,
      productId, quantity, unitCost, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierInvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.description == this.description &&
          other.category == this.category &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitCost == this.unitCost &&
          other.total == this.total);
}

class SupplierInvoiceItemsCompanion
    extends UpdateCompanion<SupplierInvoiceItem> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<String> description;
  final Value<String?> category;
  final Value<int?> productId;
  final Value<double> quantity;
  final Value<double> unitCost;
  final Value<double> total;
  const SupplierInvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.total = const Value.absent(),
  });
  SupplierInvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required String description,
    this.category = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    required double unitCost,
    required double total,
  })  : invoiceId = Value(invoiceId),
        description = Value(description),
        unitCost = Value(unitCost),
        total = Value(total);
  static Insertable<SupplierInvoiceItem> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<double>? unitCost,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitCost != null) 'unit_cost': unitCost,
      if (total != null) 'total': total,
    });
  }

  SupplierInvoiceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<String>? description,
      Value<String?>? category,
      Value<int?>? productId,
      Value<double>? quantity,
      Value<double>? unitCost,
      Value<double>? total}) {
    return SupplierInvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      category: category ?? this.category,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierInvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $AllocationsTable allocations = $AllocationsTable(this);
  late final $ProductPurchasesTable productPurchases =
      $ProductPurchasesTable(this);
  late final $StockAllocationsTable stockAllocations =
      $StockAllocationsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $FinanceAgreementsTable financeAgreements =
      $FinanceAgreementsTable(this);
  late final $FinancePaymentsTable financePayments =
      $FinancePaymentsTable(this);
  late final $FinanceSaleLinksTable financeSaleLinks =
      $FinanceSaleLinksTable(this);
  late final $SupplierInvoicesTable supplierInvoices =
      $SupplierInvoicesTable(this);
  late final $SupplierInvoiceItemsTable supplierInvoiceItems =
      $SupplierInvoiceItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        people,
        suppliers,
        products,
        sales,
        saleItems,
        payments,
        allocations,
        productPurchases,
        stockAllocations,
        expenses,
        expenseCategories,
        financeAgreements,
        financePayments,
        financeSaleLinks,
        supplierInvoices,
        supplierInvoiceItems
      ];
}

typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<double> startBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<String?> dueDate,
  Value<int> isDeleted,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<double> startBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<String?> dueDate,
  Value<int> isDeleted,
});

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startBalance => $composableBuilder(
      column: $table.startBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startBalance => $composableBuilder(
      column: $table.startBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get startBalance => $composableBuilder(
      column: $table.startBalance, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PeopleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeopleTable,
    PeopleData,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (PeopleData, BaseReferences<_$AppDatabase, $PeopleTable, PeopleData>),
    PeopleData,
    PrefetchHooks Function()> {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> startBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PeopleCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            startBalance: startBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            dueDate: dueDate,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> startBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PeopleCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            startBalance: startBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            dueDate: dueDate,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PeopleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeopleTable,
    PeopleData,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (PeopleData, BaseReferences<_$AppDatabase, $PeopleTable, PeopleData>),
    PeopleData,
    PrefetchHooks Function()>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<String> accountCode,
  Value<String?> expenseCategory,
  Value<double> openingBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<String?> dueDate,
  Value<String?> terms,
  Value<int> isDeleted,
  required String createdAt,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<String> accountCode,
  Value<String?> expenseCategory,
  Value<double> openingBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<String?> dueDate,
  Value<String?> terms,
  Value<int> isDeleted,
  Value<String> createdAt,
});

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountCode => $composableBuilder(
      column: $table.accountCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expenseCategory => $composableBuilder(
      column: $table.expenseCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get terms => $composableBuilder(
      column: $table.terms, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountCode => $composableBuilder(
      column: $table.accountCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expenseCategory => $composableBuilder(
      column: $table.expenseCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get terms => $composableBuilder(
      column: $table.terms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get accountCode => $composableBuilder(
      column: $table.accountCode, builder: (column) => column);

  GeneratedColumn<String> get expenseCategory => $composableBuilder(
      column: $table.expenseCategory, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get terms =>
      $composableBuilder(column: $table.terms, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
    Supplier,
    PrefetchHooks Function()> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> accountCode = const Value.absent(),
            Value<String?> expenseCategory = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<String?> terms = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            accountCode: accountCode,
            expenseCategory: expenseCategory,
            openingBalance: openingBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            dueDate: dueDate,
            terms: terms,
            isDeleted: isDeleted,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> accountCode = const Value.absent(),
            Value<String?> expenseCategory = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<String?> terms = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
            required String createdAt,
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            accountCode: accountCode,
            expenseCategory: expenseCategory,
            openingBalance: openingBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            dueDate: dueDate,
            terms: terms,
            isDeleted: isDeleted,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
    Supplier,
    PrefetchHooks Function()>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required double price,
  Value<String?> category,
  Value<bool> trackStock,
  Value<double> currentStock,
  Value<double> avgCost,
  Value<double> reorderLevel,
  Value<double> bundle1Qty,
  Value<double> bundle1Price,
  Value<double> bundle2Qty,
  Value<double> bundle2Price,
  Value<double> bundle3Qty,
  Value<double> bundle3Price,
  Value<double> bundle4Qty,
  Value<double> bundle4Price,
  Value<double> bundle5Qty,
  Value<double> bundle5Price,
  Value<int> isDeleted,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<double> price,
  Value<String?> category,
  Value<bool> trackStock,
  Value<double> currentStock,
  Value<double> avgCost,
  Value<double> reorderLevel,
  Value<double> bundle1Qty,
  Value<double> bundle1Price,
  Value<double> bundle2Qty,
  Value<double> bundle2Price,
  Value<double> bundle3Qty,
  Value<double> bundle3Price,
  Value<double> bundle4Qty,
  Value<double> bundle4Price,
  Value<double> bundle5Qty,
  Value<double> bundle5Price,
  Value<int> isDeleted,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentStock => $composableBuilder(
      column: $table.currentStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => column);

  GeneratedColumn<double> get avgCost =>
      $composableBuilder(column: $table.avgCost, builder: (column) => column);

  GeneratedColumn<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel, builder: (column) => column);

  GeneratedColumn<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price, builder: (column) => column);

  GeneratedColumn<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price, builder: (column) => column);

  GeneratedColumn<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price, builder: (column) => column);

  GeneratedColumn<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price, builder: (column) => column);

  GeneratedColumn<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> avgCost = const Value.absent(),
            Value<double> reorderLevel = const Value.absent(),
            Value<double> bundle1Qty = const Value.absent(),
            Value<double> bundle1Price = const Value.absent(),
            Value<double> bundle2Qty = const Value.absent(),
            Value<double> bundle2Price = const Value.absent(),
            Value<double> bundle3Qty = const Value.absent(),
            Value<double> bundle3Price = const Value.absent(),
            Value<double> bundle4Qty = const Value.absent(),
            Value<double> bundle4Price = const Value.absent(),
            Value<double> bundle5Qty = const Value.absent(),
            Value<double> bundle5Price = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            price: price,
            category: category,
            trackStock: trackStock,
            currentStock: currentStock,
            avgCost: avgCost,
            reorderLevel: reorderLevel,
            bundle1Qty: bundle1Qty,
            bundle1Price: bundle1Price,
            bundle2Qty: bundle2Qty,
            bundle2Price: bundle2Price,
            bundle3Qty: bundle3Qty,
            bundle3Price: bundle3Price,
            bundle4Qty: bundle4Qty,
            bundle4Price: bundle4Price,
            bundle5Qty: bundle5Qty,
            bundle5Price: bundle5Price,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required double price,
            Value<String?> category = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> avgCost = const Value.absent(),
            Value<double> reorderLevel = const Value.absent(),
            Value<double> bundle1Qty = const Value.absent(),
            Value<double> bundle1Price = const Value.absent(),
            Value<double> bundle2Qty = const Value.absent(),
            Value<double> bundle2Price = const Value.absent(),
            Value<double> bundle3Qty = const Value.absent(),
            Value<double> bundle3Price = const Value.absent(),
            Value<double> bundle4Qty = const Value.absent(),
            Value<double> bundle4Price = const Value.absent(),
            Value<double> bundle5Qty = const Value.absent(),
            Value<double> bundle5Price = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            price: price,
            category: category,
            trackStock: trackStock,
            currentStock: currentStock,
            avgCost: avgCost,
            reorderLevel: reorderLevel,
            bundle1Qty: bundle1Qty,
            bundle1Price: bundle1Price,
            bundle2Qty: bundle2Qty,
            bundle2Price: bundle2Price,
            bundle3Qty: bundle3Qty,
            bundle3Price: bundle3Price,
            bundle4Qty: bundle4Qty,
            bundle4Price: bundle4Price,
            bundle5Qty: bundle5Qty,
            bundle5Price: bundle5Price,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required int personId,
  required String invoiceNumber,
  required String date,
  Value<String?> dueDate,
  Value<String> saleType,
  required double total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<int> personId,
  Value<String> invoiceNumber,
  Value<String> date,
  Value<String?> dueDate,
  Value<String> saleType,
  Value<double> total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get saleType =>
      $composableBuilder(column: $table.saleType, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<String> saleType = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            personId: personId,
            invoiceNumber: invoiceNumber,
            date: date,
            dueDate: dueDate,
            saleType: saleType,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personId,
            required String invoiceNumber,
            required String date,
            Value<String?> dueDate = const Value.absent(),
            Value<String> saleType = const Value.absent(),
            required double total,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            personId: personId,
            invoiceNumber: invoiceNumber,
            date: date,
            dueDate: dueDate,
            saleType: saleType,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  required int saleId,
  required int productId,
  required double quantity,
  required double price,
  required double total,
  Value<double> costOfGoods,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  Value<int> saleId,
  Value<int> productId,
  Value<double> quantity,
  Value<double> price,
  Value<double> total,
  Value<double> costOfGoods,
});

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => ColumnFilters(column));
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => ColumnOrderings(column));
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => column);
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<double> costOfGoods = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
            total: total,
            costOfGoods: costOfGoods,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleId,
            required int productId,
            required double quantity,
            required double price,
            required double total,
            Value<double> costOfGoods = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
            total: total,
            costOfGoods: costOfGoods,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int personId,
  required String date,
  required double amount,
  Value<String> paymentType,
  Value<String> receiptType,
  required String paymentMethod,
  Value<String?> reference,
  Value<int> isDeleted,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> personId,
  Value<String> date,
  Value<double> amount,
  Value<String> paymentType,
  Value<String> receiptType,
  Value<String> paymentMethod,
  Value<String?> reference,
  Value<int> isDeleted,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptType => $composableBuilder(
      column: $table.receiptType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptType => $composableBuilder(
      column: $table.receiptType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
      column: $table.paymentType, builder: (column) => column);

  GeneratedColumn<String> get receiptType => $composableBuilder(
      column: $table.receiptType, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paymentType = const Value.absent(),
            Value<String> receiptType = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            personId: personId,
            date: date,
            amount: amount,
            paymentType: paymentType,
            receiptType: receiptType,
            paymentMethod: paymentMethod,
            reference: reference,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personId,
            required String date,
            required double amount,
            Value<String> paymentType = const Value.absent(),
            Value<String> receiptType = const Value.absent(),
            required String paymentMethod,
            Value<String?> reference = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            personId: personId,
            date: date,
            amount: amount,
            paymentType: paymentType,
            receiptType: receiptType,
            paymentMethod: paymentMethod,
            reference: reference,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()>;
typedef $$AllocationsTableCreateCompanionBuilder = AllocationsCompanion
    Function({
  Value<int> id,
  required int paymentId,
  required int allocatedItemId,
  Value<String> allocatedItemType,
  required double amount,
  Value<int> isActive,
});
typedef $$AllocationsTableUpdateCompanionBuilder = AllocationsCompanion
    Function({
  Value<int> id,
  Value<int> paymentId,
  Value<int> allocatedItemId,
  Value<String> allocatedItemType,
  Value<double> amount,
  Value<int> isActive,
});

class $$AllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentId => $composableBuilder(
      column: $table.paymentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get allocatedItemId => $composableBuilder(
      column: $table.allocatedItemId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allocatedItemType => $composableBuilder(
      column: $table.allocatedItemType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$AllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentId => $composableBuilder(
      column: $table.paymentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get allocatedItemId => $composableBuilder(
      column: $table.allocatedItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allocatedItemType => $composableBuilder(
      column: $table.allocatedItemType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$AllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<int> get allocatedItemId => $composableBuilder(
      column: $table.allocatedItemId, builder: (column) => column);

  GeneratedColumn<String> get allocatedItemType => $composableBuilder(
      column: $table.allocatedItemType, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$AllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AllocationsTable,
    Allocation,
    $$AllocationsTableFilterComposer,
    $$AllocationsTableOrderingComposer,
    $$AllocationsTableAnnotationComposer,
    $$AllocationsTableCreateCompanionBuilder,
    $$AllocationsTableUpdateCompanionBuilder,
    (Allocation, BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>),
    Allocation,
    PrefetchHooks Function()> {
  $$AllocationsTableTableManager(_$AppDatabase db, $AllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> paymentId = const Value.absent(),
            Value<int> allocatedItemId = const Value.absent(),
            Value<String> allocatedItemType = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> isActive = const Value.absent(),
          }) =>
              AllocationsCompanion(
            id: id,
            paymentId: paymentId,
            allocatedItemId: allocatedItemId,
            allocatedItemType: allocatedItemType,
            amount: amount,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int paymentId,
            required int allocatedItemId,
            Value<String> allocatedItemType = const Value.absent(),
            required double amount,
            Value<int> isActive = const Value.absent(),
          }) =>
              AllocationsCompanion.insert(
            id: id,
            paymentId: paymentId,
            allocatedItemId: allocatedItemId,
            allocatedItemType: allocatedItemType,
            amount: amount,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AllocationsTable,
    Allocation,
    $$AllocationsTableFilterComposer,
    $$AllocationsTableOrderingComposer,
    $$AllocationsTableAnnotationComposer,
    $$AllocationsTableCreateCompanionBuilder,
    $$AllocationsTableUpdateCompanionBuilder,
    (Allocation, BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>),
    Allocation,
    PrefetchHooks Function()>;
typedef $$ProductPurchasesTableCreateCompanionBuilder
    = ProductPurchasesCompanion Function({
  Value<int> id,
  required int productId,
  Value<int?> supplierId,
  required String date,
  required double quantity,
  Value<double> qtyPerUnit,
  required double costPerUnit,
  required double totalCost,
  required double remainingQuantity,
});
typedef $$ProductPurchasesTableUpdateCompanionBuilder
    = ProductPurchasesCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int?> supplierId,
  Value<String> date,
  Value<double> quantity,
  Value<double> qtyPerUnit,
  Value<double> costPerUnit,
  Value<double> totalCost,
  Value<double> remainingQuantity,
});

class $$ProductPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity,
      builder: (column) => ColumnFilters(column));
}

class $$ProductPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity, builder: (column) => column);
}

class $$ProductPurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductPurchasesTable,
    ProductPurchase,
    $$ProductPurchasesTableFilterComposer,
    $$ProductPurchasesTableOrderingComposer,
    $$ProductPurchasesTableAnnotationComposer,
    $$ProductPurchasesTableCreateCompanionBuilder,
    $$ProductPurchasesTableUpdateCompanionBuilder,
    (
      ProductPurchase,
      BaseReferences<_$AppDatabase, $ProductPurchasesTable, ProductPurchase>
    ),
    ProductPurchase,
    PrefetchHooks Function()> {
  $$ProductPurchasesTableTableManager(
      _$AppDatabase db, $ProductPurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> qtyPerUnit = const Value.absent(),
            Value<double> costPerUnit = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> remainingQuantity = const Value.absent(),
          }) =>
              ProductPurchasesCompanion(
            id: id,
            productId: productId,
            supplierId: supplierId,
            date: date,
            quantity: quantity,
            qtyPerUnit: qtyPerUnit,
            costPerUnit: costPerUnit,
            totalCost: totalCost,
            remainingQuantity: remainingQuantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            Value<int?> supplierId = const Value.absent(),
            required String date,
            required double quantity,
            Value<double> qtyPerUnit = const Value.absent(),
            required double costPerUnit,
            required double totalCost,
            required double remainingQuantity,
          }) =>
              ProductPurchasesCompanion.insert(
            id: id,
            productId: productId,
            supplierId: supplierId,
            date: date,
            quantity: quantity,
            qtyPerUnit: qtyPerUnit,
            costPerUnit: costPerUnit,
            totalCost: totalCost,
            remainingQuantity: remainingQuantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductPurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductPurchasesTable,
    ProductPurchase,
    $$ProductPurchasesTableFilterComposer,
    $$ProductPurchasesTableOrderingComposer,
    $$ProductPurchasesTableAnnotationComposer,
    $$ProductPurchasesTableCreateCompanionBuilder,
    $$ProductPurchasesTableUpdateCompanionBuilder,
    (
      ProductPurchase,
      BaseReferences<_$AppDatabase, $ProductPurchasesTable, ProductPurchase>
    ),
    ProductPurchase,
    PrefetchHooks Function()>;
typedef $$StockAllocationsTableCreateCompanionBuilder
    = StockAllocationsCompanion Function({
  Value<int> id,
  required int saleItemId,
  required int purchaseId,
  required double quantity,
  required double costPerUnit,
});
typedef $$StockAllocationsTableUpdateCompanionBuilder
    = StockAllocationsCompanion Function({
  Value<int> id,
  Value<int> saleItemId,
  Value<int> purchaseId,
  Value<double> quantity,
  Value<double> costPerUnit,
});

class $$StockAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnFilters(column));
}

class $$StockAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnOrderings(column));
}

class $$StockAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => column);

  GeneratedColumn<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => column);
}

class $$StockAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockAllocationsTable,
    StockAllocation,
    $$StockAllocationsTableFilterComposer,
    $$StockAllocationsTableOrderingComposer,
    $$StockAllocationsTableAnnotationComposer,
    $$StockAllocationsTableCreateCompanionBuilder,
    $$StockAllocationsTableUpdateCompanionBuilder,
    (
      StockAllocation,
      BaseReferences<_$AppDatabase, $StockAllocationsTable, StockAllocation>
    ),
    StockAllocation,
    PrefetchHooks Function()> {
  $$StockAllocationsTableTableManager(
      _$AppDatabase db, $StockAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockAllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleItemId = const Value.absent(),
            Value<int> purchaseId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> costPerUnit = const Value.absent(),
          }) =>
              StockAllocationsCompanion(
            id: id,
            saleItemId: saleItemId,
            purchaseId: purchaseId,
            quantity: quantity,
            costPerUnit: costPerUnit,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleItemId,
            required int purchaseId,
            required double quantity,
            required double costPerUnit,
          }) =>
              StockAllocationsCompanion.insert(
            id: id,
            saleItemId: saleItemId,
            purchaseId: purchaseId,
            quantity: quantity,
            costPerUnit: costPerUnit,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StockAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockAllocationsTable,
    StockAllocation,
    $$StockAllocationsTableFilterComposer,
    $$StockAllocationsTableOrderingComposer,
    $$StockAllocationsTableAnnotationComposer,
    $$StockAllocationsTableCreateCompanionBuilder,
    $$StockAllocationsTableUpdateCompanionBuilder,
    (
      StockAllocation,
      BaseReferences<_$AppDatabase, $StockAllocationsTable, StockAllocation>
    ),
    StockAllocation,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String date,
  required String category,
  required String description,
  required double amount,
  Value<String?> paymentMethod,
  Value<String?> reference,
  Value<int?> personId,
  Value<int> isDeleted,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> category,
  Value<String> description,
  Value<double> amount,
  Value<String?> paymentMethod,
  Value<String?> reference,
  Value<int?> personId,
  Value<int> isDeleted,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int?> personId = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            personId: personId,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required String category,
            required String description,
            required double amount,
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int?> personId = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            personId: personId,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> color,
  Value<String> icon,
  Value<int> isDefault,
  Value<int> isDeleted,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> color,
  Value<String> icon,
  Value<int> isDefault,
  Value<int> isDeleted,
});

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> isDefault = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            name: name,
            color: color,
            icon: icon,
            isDefault: isDefault,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> isDefault = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            name: name,
            color: color,
            icon: icon,
            isDefault: isDefault,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()>;
typedef $$FinanceAgreementsTableCreateCompanionBuilder
    = FinanceAgreementsCompanion Function({
  Value<int> id,
  required String customerName,
  Value<String?> customerAddress,
  required String agreementDate,
  required double loanAmount,
  required double interestRate,
  Value<String> paymentFrequency,
  required int paymentCount,
  required String firstPaymentDate,
  required double paymentAmount,
  required double totalInterest,
  required double totalRepayable,
  Value<String> status,
  Value<String> financeSource,
  Value<int?> linkedPersonId,
  Value<double?> sourceSalesAmount,
  Value<double?> additionalAmount,
  Value<String?> purposeNote,
  Value<String?> assetNote,
  required String createdAt,
  Value<int> isDeleted,
});
typedef $$FinanceAgreementsTableUpdateCompanionBuilder
    = FinanceAgreementsCompanion Function({
  Value<int> id,
  Value<String> customerName,
  Value<String?> customerAddress,
  Value<String> agreementDate,
  Value<double> loanAmount,
  Value<double> interestRate,
  Value<String> paymentFrequency,
  Value<int> paymentCount,
  Value<String> firstPaymentDate,
  Value<double> paymentAmount,
  Value<double> totalInterest,
  Value<double> totalRepayable,
  Value<String> status,
  Value<String> financeSource,
  Value<int?> linkedPersonId,
  Value<double?> sourceSalesAmount,
  Value<double?> additionalAmount,
  Value<String?> purposeNote,
  Value<String?> assetNote,
  Value<String> createdAt,
  Value<int> isDeleted,
});

class $$FinanceAgreementsTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceAgreementsTable> {
  $$FinanceAgreementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agreementDate => $composableBuilder(
      column: $table.agreementDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentCount => $composableBuilder(
      column: $table.paymentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstPaymentDate => $composableBuilder(
      column: $table.firstPaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalInterest => $composableBuilder(
      column: $table.totalInterest, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalRepayable => $composableBuilder(
      column: $table.totalRepayable,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get financeSource => $composableBuilder(
      column: $table.financeSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get linkedPersonId => $composableBuilder(
      column: $table.linkedPersonId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sourceSalesAmount => $composableBuilder(
      column: $table.sourceSalesAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get additionalAmount => $composableBuilder(
      column: $table.additionalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purposeNote => $composableBuilder(
      column: $table.purposeNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetNote => $composableBuilder(
      column: $table.assetNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$FinanceAgreementsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceAgreementsTable> {
  $$FinanceAgreementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agreementDate => $composableBuilder(
      column: $table.agreementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentCount => $composableBuilder(
      column: $table.paymentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstPaymentDate => $composableBuilder(
      column: $table.firstPaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalInterest => $composableBuilder(
      column: $table.totalInterest,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalRepayable => $composableBuilder(
      column: $table.totalRepayable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get financeSource => $composableBuilder(
      column: $table.financeSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get linkedPersonId => $composableBuilder(
      column: $table.linkedPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sourceSalesAmount => $composableBuilder(
      column: $table.sourceSalesAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get additionalAmount => $composableBuilder(
      column: $table.additionalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purposeNote => $composableBuilder(
      column: $table.purposeNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetNote => $composableBuilder(
      column: $table.assetNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$FinanceAgreementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceAgreementsTable> {
  $$FinanceAgreementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress, builder: (column) => column);

  GeneratedColumn<String> get agreementDate => $composableBuilder(
      column: $table.agreementDate, builder: (column) => column);

  GeneratedColumn<double> get loanAmount => $composableBuilder(
      column: $table.loanAmount, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency, builder: (column) => column);

  GeneratedColumn<int> get paymentCount => $composableBuilder(
      column: $table.paymentCount, builder: (column) => column);

  GeneratedColumn<String> get firstPaymentDate => $composableBuilder(
      column: $table.firstPaymentDate, builder: (column) => column);

  GeneratedColumn<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => column);

  GeneratedColumn<double> get totalInterest => $composableBuilder(
      column: $table.totalInterest, builder: (column) => column);

  GeneratedColumn<double> get totalRepayable => $composableBuilder(
      column: $table.totalRepayable, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get financeSource => $composableBuilder(
      column: $table.financeSource, builder: (column) => column);

  GeneratedColumn<int> get linkedPersonId => $composableBuilder(
      column: $table.linkedPersonId, builder: (column) => column);

  GeneratedColumn<double> get sourceSalesAmount => $composableBuilder(
      column: $table.sourceSalesAmount, builder: (column) => column);

  GeneratedColumn<double> get additionalAmount => $composableBuilder(
      column: $table.additionalAmount, builder: (column) => column);

  GeneratedColumn<String> get purposeNote => $composableBuilder(
      column: $table.purposeNote, builder: (column) => column);

  GeneratedColumn<String> get assetNote =>
      $composableBuilder(column: $table.assetNote, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$FinanceAgreementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinanceAgreementsTable,
    FinanceAgreement,
    $$FinanceAgreementsTableFilterComposer,
    $$FinanceAgreementsTableOrderingComposer,
    $$FinanceAgreementsTableAnnotationComposer,
    $$FinanceAgreementsTableCreateCompanionBuilder,
    $$FinanceAgreementsTableUpdateCompanionBuilder,
    (
      FinanceAgreement,
      BaseReferences<_$AppDatabase, $FinanceAgreementsTable, FinanceAgreement>
    ),
    FinanceAgreement,
    PrefetchHooks Function()> {
  $$FinanceAgreementsTableTableManager(
      _$AppDatabase db, $FinanceAgreementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceAgreementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceAgreementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceAgreementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerAddress = const Value.absent(),
            Value<String> agreementDate = const Value.absent(),
            Value<double> loanAmount = const Value.absent(),
            Value<double> interestRate = const Value.absent(),
            Value<String> paymentFrequency = const Value.absent(),
            Value<int> paymentCount = const Value.absent(),
            Value<String> firstPaymentDate = const Value.absent(),
            Value<double> paymentAmount = const Value.absent(),
            Value<double> totalInterest = const Value.absent(),
            Value<double> totalRepayable = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> financeSource = const Value.absent(),
            Value<int?> linkedPersonId = const Value.absent(),
            Value<double?> sourceSalesAmount = const Value.absent(),
            Value<double?> additionalAmount = const Value.absent(),
            Value<String?> purposeNote = const Value.absent(),
            Value<String?> assetNote = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              FinanceAgreementsCompanion(
            id: id,
            customerName: customerName,
            customerAddress: customerAddress,
            agreementDate: agreementDate,
            loanAmount: loanAmount,
            interestRate: interestRate,
            paymentFrequency: paymentFrequency,
            paymentCount: paymentCount,
            firstPaymentDate: firstPaymentDate,
            paymentAmount: paymentAmount,
            totalInterest: totalInterest,
            totalRepayable: totalRepayable,
            status: status,
            financeSource: financeSource,
            linkedPersonId: linkedPersonId,
            sourceSalesAmount: sourceSalesAmount,
            additionalAmount: additionalAmount,
            purposeNote: purposeNote,
            assetNote: assetNote,
            createdAt: createdAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String customerName,
            Value<String?> customerAddress = const Value.absent(),
            required String agreementDate,
            required double loanAmount,
            required double interestRate,
            Value<String> paymentFrequency = const Value.absent(),
            required int paymentCount,
            required String firstPaymentDate,
            required double paymentAmount,
            required double totalInterest,
            required double totalRepayable,
            Value<String> status = const Value.absent(),
            Value<String> financeSource = const Value.absent(),
            Value<int?> linkedPersonId = const Value.absent(),
            Value<double?> sourceSalesAmount = const Value.absent(),
            Value<double?> additionalAmount = const Value.absent(),
            Value<String?> purposeNote = const Value.absent(),
            Value<String?> assetNote = const Value.absent(),
            required String createdAt,
            Value<int> isDeleted = const Value.absent(),
          }) =>
              FinanceAgreementsCompanion.insert(
            id: id,
            customerName: customerName,
            customerAddress: customerAddress,
            agreementDate: agreementDate,
            loanAmount: loanAmount,
            interestRate: interestRate,
            paymentFrequency: paymentFrequency,
            paymentCount: paymentCount,
            firstPaymentDate: firstPaymentDate,
            paymentAmount: paymentAmount,
            totalInterest: totalInterest,
            totalRepayable: totalRepayable,
            status: status,
            financeSource: financeSource,
            linkedPersonId: linkedPersonId,
            sourceSalesAmount: sourceSalesAmount,
            additionalAmount: additionalAmount,
            purposeNote: purposeNote,
            assetNote: assetNote,
            createdAt: createdAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinanceAgreementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinanceAgreementsTable,
    FinanceAgreement,
    $$FinanceAgreementsTableFilterComposer,
    $$FinanceAgreementsTableOrderingComposer,
    $$FinanceAgreementsTableAnnotationComposer,
    $$FinanceAgreementsTableCreateCompanionBuilder,
    $$FinanceAgreementsTableUpdateCompanionBuilder,
    (
      FinanceAgreement,
      BaseReferences<_$AppDatabase, $FinanceAgreementsTable, FinanceAgreement>
    ),
    FinanceAgreement,
    PrefetchHooks Function()>;
typedef $$FinancePaymentsTableCreateCompanionBuilder = FinancePaymentsCompanion
    Function({
  Value<int> id,
  required int agreementId,
  required int paymentNo,
  required String dueDate,
  required double openingBalance,
  required double paymentAmount,
  required double interestAmount,
  required double capitalAmount,
  required double closingBalance,
  Value<int> paid,
  Value<String?> paidDate,
  Value<String> rowType,
});
typedef $$FinancePaymentsTableUpdateCompanionBuilder = FinancePaymentsCompanion
    Function({
  Value<int> id,
  Value<int> agreementId,
  Value<int> paymentNo,
  Value<String> dueDate,
  Value<double> openingBalance,
  Value<double> paymentAmount,
  Value<double> interestAmount,
  Value<double> capitalAmount,
  Value<double> closingBalance,
  Value<int> paid,
  Value<String?> paidDate,
  Value<String> rowType,
});

class $$FinancePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancePaymentsTable> {
  $$FinancePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentNo => $composableBuilder(
      column: $table.paymentNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestAmount => $composableBuilder(
      column: $table.interestAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get capitalAmount => $composableBuilder(
      column: $table.capitalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paid => $composableBuilder(
      column: $table.paid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidDate => $composableBuilder(
      column: $table.paidDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rowType => $composableBuilder(
      column: $table.rowType, builder: (column) => ColumnFilters(column));
}

class $$FinancePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancePaymentsTable> {
  $$FinancePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentNo => $composableBuilder(
      column: $table.paymentNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestAmount => $composableBuilder(
      column: $table.interestAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get capitalAmount => $composableBuilder(
      column: $table.capitalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paid => $composableBuilder(
      column: $table.paid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidDate => $composableBuilder(
      column: $table.paidDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rowType => $composableBuilder(
      column: $table.rowType, builder: (column) => ColumnOrderings(column));
}

class $$FinancePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancePaymentsTable> {
  $$FinancePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => column);

  GeneratedColumn<int> get paymentNo =>
      $composableBuilder(column: $table.paymentNo, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<double> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => column);

  GeneratedColumn<double> get interestAmount => $composableBuilder(
      column: $table.interestAmount, builder: (column) => column);

  GeneratedColumn<double> get capitalAmount => $composableBuilder(
      column: $table.capitalAmount, builder: (column) => column);

  GeneratedColumn<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance, builder: (column) => column);

  GeneratedColumn<int> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<String> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<String> get rowType =>
      $composableBuilder(column: $table.rowType, builder: (column) => column);
}

class $$FinancePaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancePaymentsTable,
    FinancePayment,
    $$FinancePaymentsTableFilterComposer,
    $$FinancePaymentsTableOrderingComposer,
    $$FinancePaymentsTableAnnotationComposer,
    $$FinancePaymentsTableCreateCompanionBuilder,
    $$FinancePaymentsTableUpdateCompanionBuilder,
    (
      FinancePayment,
      BaseReferences<_$AppDatabase, $FinancePaymentsTable, FinancePayment>
    ),
    FinancePayment,
    PrefetchHooks Function()> {
  $$FinancePaymentsTableTableManager(
      _$AppDatabase db, $FinancePaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> agreementId = const Value.absent(),
            Value<int> paymentNo = const Value.absent(),
            Value<String> dueDate = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double> paymentAmount = const Value.absent(),
            Value<double> interestAmount = const Value.absent(),
            Value<double> capitalAmount = const Value.absent(),
            Value<double> closingBalance = const Value.absent(),
            Value<int> paid = const Value.absent(),
            Value<String?> paidDate = const Value.absent(),
            Value<String> rowType = const Value.absent(),
          }) =>
              FinancePaymentsCompanion(
            id: id,
            agreementId: agreementId,
            paymentNo: paymentNo,
            dueDate: dueDate,
            openingBalance: openingBalance,
            paymentAmount: paymentAmount,
            interestAmount: interestAmount,
            capitalAmount: capitalAmount,
            closingBalance: closingBalance,
            paid: paid,
            paidDate: paidDate,
            rowType: rowType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int agreementId,
            required int paymentNo,
            required String dueDate,
            required double openingBalance,
            required double paymentAmount,
            required double interestAmount,
            required double capitalAmount,
            required double closingBalance,
            Value<int> paid = const Value.absent(),
            Value<String?> paidDate = const Value.absent(),
            Value<String> rowType = const Value.absent(),
          }) =>
              FinancePaymentsCompanion.insert(
            id: id,
            agreementId: agreementId,
            paymentNo: paymentNo,
            dueDate: dueDate,
            openingBalance: openingBalance,
            paymentAmount: paymentAmount,
            interestAmount: interestAmount,
            capitalAmount: capitalAmount,
            closingBalance: closingBalance,
            paid: paid,
            paidDate: paidDate,
            rowType: rowType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancePaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinancePaymentsTable,
    FinancePayment,
    $$FinancePaymentsTableFilterComposer,
    $$FinancePaymentsTableOrderingComposer,
    $$FinancePaymentsTableAnnotationComposer,
    $$FinancePaymentsTableCreateCompanionBuilder,
    $$FinancePaymentsTableUpdateCompanionBuilder,
    (
      FinancePayment,
      BaseReferences<_$AppDatabase, $FinancePaymentsTable, FinancePayment>
    ),
    FinancePayment,
    PrefetchHooks Function()>;
typedef $$FinanceSaleLinksTableCreateCompanionBuilder
    = FinanceSaleLinksCompanion Function({
  Value<int> id,
  required int agreementId,
  required int saleId,
});
typedef $$FinanceSaleLinksTableUpdateCompanionBuilder
    = FinanceSaleLinksCompanion Function({
  Value<int> id,
  Value<int> agreementId,
  Value<int> saleId,
});

class $$FinanceSaleLinksTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceSaleLinksTable> {
  $$FinanceSaleLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));
}

class $$FinanceSaleLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceSaleLinksTable> {
  $$FinanceSaleLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));
}

class $$FinanceSaleLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceSaleLinksTable> {
  $$FinanceSaleLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);
}

class $$FinanceSaleLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinanceSaleLinksTable,
    FinanceSaleLink,
    $$FinanceSaleLinksTableFilterComposer,
    $$FinanceSaleLinksTableOrderingComposer,
    $$FinanceSaleLinksTableAnnotationComposer,
    $$FinanceSaleLinksTableCreateCompanionBuilder,
    $$FinanceSaleLinksTableUpdateCompanionBuilder,
    (
      FinanceSaleLink,
      BaseReferences<_$AppDatabase, $FinanceSaleLinksTable, FinanceSaleLink>
    ),
    FinanceSaleLink,
    PrefetchHooks Function()> {
  $$FinanceSaleLinksTableTableManager(
      _$AppDatabase db, $FinanceSaleLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceSaleLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceSaleLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinanceSaleLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> agreementId = const Value.absent(),
            Value<int> saleId = const Value.absent(),
          }) =>
              FinanceSaleLinksCompanion(
            id: id,
            agreementId: agreementId,
            saleId: saleId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int agreementId,
            required int saleId,
          }) =>
              FinanceSaleLinksCompanion.insert(
            id: id,
            agreementId: agreementId,
            saleId: saleId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinanceSaleLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinanceSaleLinksTable,
    FinanceSaleLink,
    $$FinanceSaleLinksTableFilterComposer,
    $$FinanceSaleLinksTableOrderingComposer,
    $$FinanceSaleLinksTableAnnotationComposer,
    $$FinanceSaleLinksTableCreateCompanionBuilder,
    $$FinanceSaleLinksTableUpdateCompanionBuilder,
    (
      FinanceSaleLink,
      BaseReferences<_$AppDatabase, $FinanceSaleLinksTable, FinanceSaleLink>
    ),
    FinanceSaleLink,
    PrefetchHooks Function()>;
typedef $$SupplierInvoicesTableCreateCompanionBuilder
    = SupplierInvoicesCompanion Function({
  Value<int> id,
  required int supplierId,
  required String invoiceNumber,
  required String date,
  Value<String?> dueDate,
  required double total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});
typedef $$SupplierInvoicesTableUpdateCompanionBuilder
    = SupplierInvoicesCompanion Function({
  Value<int> id,
  Value<int> supplierId,
  Value<String> invoiceNumber,
  Value<String> date,
  Value<String?> dueDate,
  Value<double> total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});

class $$SupplierInvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$SupplierInvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$SupplierInvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SupplierInvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplierInvoicesTable,
    SupplierInvoice,
    $$SupplierInvoicesTableFilterComposer,
    $$SupplierInvoicesTableOrderingComposer,
    $$SupplierInvoicesTableAnnotationComposer,
    $$SupplierInvoicesTableCreateCompanionBuilder,
    $$SupplierInvoicesTableUpdateCompanionBuilder,
    (
      SupplierInvoice,
      BaseReferences<_$AppDatabase, $SupplierInvoicesTable, SupplierInvoice>
    ),
    SupplierInvoice,
    PrefetchHooks Function()> {
  $$SupplierInvoicesTableTableManager(
      _$AppDatabase db, $SupplierInvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SupplierInvoicesCompanion(
            id: id,
            supplierId: supplierId,
            invoiceNumber: invoiceNumber,
            date: date,
            dueDate: dueDate,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int supplierId,
            required String invoiceNumber,
            required String date,
            Value<String?> dueDate = const Value.absent(),
            required double total,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SupplierInvoicesCompanion.insert(
            id: id,
            supplierId: supplierId,
            invoiceNumber: invoiceNumber,
            date: date,
            dueDate: dueDate,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SupplierInvoicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SupplierInvoicesTable,
    SupplierInvoice,
    $$SupplierInvoicesTableFilterComposer,
    $$SupplierInvoicesTableOrderingComposer,
    $$SupplierInvoicesTableAnnotationComposer,
    $$SupplierInvoicesTableCreateCompanionBuilder,
    $$SupplierInvoicesTableUpdateCompanionBuilder,
    (
      SupplierInvoice,
      BaseReferences<_$AppDatabase, $SupplierInvoicesTable, SupplierInvoice>
    ),
    SupplierInvoice,
    PrefetchHooks Function()>;
typedef $$SupplierInvoiceItemsTableCreateCompanionBuilder
    = SupplierInvoiceItemsCompanion Function({
  Value<int> id,
  required int invoiceId,
  required String description,
  Value<String?> category,
  Value<int?> productId,
  Value<double> quantity,
  required double unitCost,
  required double total,
});
typedef $$SupplierInvoiceItemsTableUpdateCompanionBuilder
    = SupplierInvoiceItemsCompanion Function({
  Value<int> id,
  Value<int> invoiceId,
  Value<String> description,
  Value<String?> category,
  Value<int?> productId,
  Value<double> quantity,
  Value<double> unitCost,
  Value<double> total,
});

class $$SupplierInvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierInvoiceItemsTable> {
  $$SupplierInvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitCost => $composableBuilder(
      column: $table.unitCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));
}

class $$SupplierInvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierInvoiceItemsTable> {
  $$SupplierInvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitCost => $composableBuilder(
      column: $table.unitCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));
}

class $$SupplierInvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierInvoiceItemsTable> {
  $$SupplierInvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);
}

class $$SupplierInvoiceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplierInvoiceItemsTable,
    SupplierInvoiceItem,
    $$SupplierInvoiceItemsTableFilterComposer,
    $$SupplierInvoiceItemsTableOrderingComposer,
    $$SupplierInvoiceItemsTableAnnotationComposer,
    $$SupplierInvoiceItemsTableCreateCompanionBuilder,
    $$SupplierInvoiceItemsTableUpdateCompanionBuilder,
    (
      SupplierInvoiceItem,
      BaseReferences<_$AppDatabase, $SupplierInvoiceItemsTable,
          SupplierInvoiceItem>
    ),
    SupplierInvoiceItem,
    PrefetchHooks Function()> {
  $$SupplierInvoiceItemsTableTableManager(
      _$AppDatabase db, $SupplierInvoiceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierInvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierInvoiceItemsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierInvoiceItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> invoiceId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int?> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> unitCost = const Value.absent(),
            Value<double> total = const Value.absent(),
          }) =>
              SupplierInvoiceItemsCompanion(
            id: id,
            invoiceId: invoiceId,
            description: description,
            category: category,
            productId: productId,
            quantity: quantity,
            unitCost: unitCost,
            total: total,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int invoiceId,
            required String description,
            Value<String?> category = const Value.absent(),
            Value<int?> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            required double unitCost,
            required double total,
          }) =>
              SupplierInvoiceItemsCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            description: description,
            category: category,
            productId: productId,
            quantity: quantity,
            unitCost: unitCost,
            total: total,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SupplierInvoiceItemsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SupplierInvoiceItemsTable,
        SupplierInvoiceItem,
        $$SupplierInvoiceItemsTableFilterComposer,
        $$SupplierInvoiceItemsTableOrderingComposer,
        $$SupplierInvoiceItemsTableAnnotationComposer,
        $$SupplierInvoiceItemsTableCreateCompanionBuilder,
        $$SupplierInvoiceItemsTableUpdateCompanionBuilder,
        (
          SupplierInvoiceItem,
          BaseReferences<_$AppDatabase, $SupplierInvoiceItemsTable,
              SupplierInvoiceItem>
        ),
        SupplierInvoiceItem,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$AllocationsTableTableManager get allocations =>
      $$AllocationsTableTableManager(_db, _db.allocations);
  $$ProductPurchasesTableTableManager get productPurchases =>
      $$ProductPurchasesTableTableManager(_db, _db.productPurchases);
  $$StockAllocationsTableTableManager get stockAllocations =>
      $$StockAllocationsTableTableManager(_db, _db.stockAllocations);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$FinanceAgreementsTableTableManager get financeAgreements =>
      $$FinanceAgreementsTableTableManager(_db, _db.financeAgreements);
  $$FinancePaymentsTableTableManager get financePayments =>
      $$FinancePaymentsTableTableManager(_db, _db.financePayments);
  $$FinanceSaleLinksTableTableManager get financeSaleLinks =>
      $$FinanceSaleLinksTableTableManager(_db, _db.financeSaleLinks);
  $$SupplierInvoicesTableTableManager get supplierInvoices =>
      $$SupplierInvoicesTableTableManager(_db, _db.supplierInvoices);
  $$SupplierInvoiceItemsTableTableManager get supplierInvoiceItems =>
      $$SupplierInvoiceItemsTableTableManager(_db, _db.supplierInvoiceItems);
}
