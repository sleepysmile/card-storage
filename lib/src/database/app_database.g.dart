// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StorageCardsTable extends StorageCards
    with TableInfo<$StorageCardsTable, StorageCardDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorageCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardNumberMeta = const VerificationMeta(
    'cardNumber',
  );
  @override
  late final GeneratedColumn<String> cardNumber = GeneratedColumn<String>(
    'card_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, barcode, cardNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorageCardDto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('card_number')) {
      context.handle(
        _cardNumberMeta,
        cardNumber.isAcceptableOrUnknown(data['card_number']!, _cardNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {barcode};
  @override
  StorageCardDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageCardDto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      cardNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_number'],
      ),
    );
  }

  @override
  $StorageCardsTable createAlias(String alias) {
    return $StorageCardsTable(attachedDatabase, alias);
  }
}

class StorageCardsCompanion extends UpdateCompanion<StorageCardDto> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> barcode;
  final Value<String?> cardNumber;
  final Value<int> rowid;
  const StorageCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageCardsCompanion.insert({
    required int id,
    required String name,
    required String barcode,
    this.cardNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       barcode = Value(barcode);
  static Insertable<StorageCardDto> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? cardNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (cardNumber != null) 'card_number': cardNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? barcode,
    Value<String?>? cardNumber,
    Value<int>? rowid,
  }) {
    return StorageCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      cardNumber: cardNumber ?? this.cardNumber,
      rowid: rowid ?? this.rowid,
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
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$StorageCardDtoInsertable implements Insertable<StorageCardDto> {
  StorageCardDto _object;
  _$StorageCardDtoInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return StorageCardsCompanion(
      id: Value(_object.id),
      name: Value(_object.name),
      barcode: Value(_object.barcode),
      cardNumber: Value(_object.cardNumber),
    ).toColumns(false);
  }
}

extension StorageCardDtoToInsertable on StorageCardDto {
  _$StorageCardDtoInsertable toInsertable() {
    return _$StorageCardDtoInsertable(this);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StorageCardsTable storageCards = $StorageCardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storageCards];
}

typedef $$StorageCardsTableCreateCompanionBuilder =
    StorageCardsCompanion Function({
      required int id,
      required String name,
      required String barcode,
      Value<String?> cardNumber,
      Value<int> rowid,
    });
typedef $$StorageCardsTableUpdateCompanionBuilder =
    StorageCardsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> barcode,
      Value<String?> cardNumber,
      Value<int> rowid,
    });

class $$StorageCardsTableFilterComposer
    extends Composer<_$AppDatabase, $StorageCardsTable> {
  $$StorageCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StorageCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $StorageCardsTable> {
  $$StorageCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StorageCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorageCardsTable> {
  $$StorageCardsTableAnnotationComposer({
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

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => column,
  );
}

class $$StorageCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorageCardsTable,
          StorageCardDto,
          $$StorageCardsTableFilterComposer,
          $$StorageCardsTableOrderingComposer,
          $$StorageCardsTableAnnotationComposer,
          $$StorageCardsTableCreateCompanionBuilder,
          $$StorageCardsTableUpdateCompanionBuilder,
          (
            StorageCardDto,
            BaseReferences<_$AppDatabase, $StorageCardsTable, StorageCardDto>,
          ),
          StorageCardDto,
          PrefetchHooks Function()
        > {
  $$StorageCardsTableTableManager(_$AppDatabase db, $StorageCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorageCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorageCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorageCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String?> cardNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorageCardsCompanion(
                id: id,
                name: name,
                barcode: barcode,
                cardNumber: cardNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String name,
                required String barcode,
                Value<String?> cardNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorageCardsCompanion.insert(
                id: id,
                name: name,
                barcode: barcode,
                cardNumber: cardNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StorageCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorageCardsTable,
      StorageCardDto,
      $$StorageCardsTableFilterComposer,
      $$StorageCardsTableOrderingComposer,
      $$StorageCardsTableAnnotationComposer,
      $$StorageCardsTableCreateCompanionBuilder,
      $$StorageCardsTableUpdateCompanionBuilder,
      (
        StorageCardDto,
        BaseReferences<_$AppDatabase, $StorageCardsTable, StorageCardDto>,
      ),
      StorageCardDto,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StorageCardsTableTableManager get storageCards =>
      $$StorageCardsTableTableManager(_db, _db.storageCards);
}
