//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDBCipher
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - SDSSerializable

extension OWSMessageDecryptJob: SDSSerializable {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSMessageDecryptJobSerializer(model: self)
        }
    }
}

// MARK: - Table Metadata

extension OWSMessageDecryptJobSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int, columnIndex: 0)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, columnIndex: 1)
    // Base class properties
    static let createdAtColumn = SDSColumnMetadata(columnName: "createdAt", columnType: .int64, columnIndex: 2)
    static let envelopeDataColumn = SDSColumnMetadata(columnName: "envelopeData", columnType: .blob, columnIndex: 3)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(tableName: "model_OWSMessageDecryptJob", columns: [
        recordTypeColumn,
        uniqueIdColumn,
        createdAtColumn,
        envelopeDataColumn
        ])

}

// MARK: - Deserialization

extension OWSMessageDecryptJobSerializer {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func sdsDeserialize(statement: SelectStatement) throws -> OWSMessageDecryptJob {

        if OWSIsDebugBuild() {
            guard statement.columnNames == table.selectColumnNames else {
                owsFailDebug("Unexpected columns: \(statement.columnNames) != \(table.selectColumnNames)")
                throw SDSError.invalidResult
            }
        }

        // SDSDeserializer is used to convert column values into Swift values.
        let deserializer = SDSDeserializer(sqliteStatement: statement.sqliteStatement)
        let recordTypeValue = try deserializer.int(at: 0)
        guard let recordType = SDSRecordType(rawValue: UInt(recordTypeValue)) else {
            owsFailDebug("Invalid recordType: \(recordTypeValue)")
            throw SDSError.invalidResult
        }
        switch recordType {
        case .messageDecryptJob:

            let uniqueId = try deserializer.string(at: uniqueIdColumn.columnIndex)
            let createdAt = try deserializer.date(at: createdAtColumn.columnIndex)
            let envelopeData = try deserializer.blob(at: envelopeDataColumn.columnIndex)

/* Suggested Initializer

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                        createdAt:(NSDate *)createdAt
                     envelopeData:(NSData *)envelopeData
NS_DESIGNATED_INITIALIZER
NS_SWIFT_NAME(init(uniqueId:createdAt:envelopeData:));
*/
            return OWSMessageDecryptJob(uniqueId: uniqueId,
                                        createdAt: createdAt,
                                        envelopeData: envelopeData)

        default:
            owsFail("Invalid record type \(recordType)")
        }
    }
}

// MARK: - Save/Remove/Update

@objc
extension OWSMessageDecryptJob {
    @objc
    public func anySave(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            save(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.save(entity: self, transaction: grdbTransaction)
        }
    }

    @objc
    public func anyRemove(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            remove(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            SDSSerialization.delete(entity: self, transaction: grdbTransaction)
        }
    }
}

// MARK: - OWSMessageDecryptJobCursor

@objc
public class OWSMessageDecryptJobCursor: NSObject {
    private let cursor: SDSCursor<OWSMessageDecryptJob>

    init(cursor: SDSCursor<OWSMessageDecryptJob>) {
        self.cursor = cursor
    }

    // TODO: Revisit error handling in this class.
    public func next() throws -> OWSMessageDecryptJob? {
        return try cursor.next()
    }

    public func all() throws -> [OWSMessageDecryptJob] {
        return try cursor.all()
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
extension OWSMessageDecryptJob {
    public class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSMessageDecryptJobCursor {
        return OWSMessageDecryptJobCursor(cursor: SDSSerialization.fetchCursor(tableMetadata: OWSMessageDecryptJobSerializer.table,
                                                                   transaction: transaction,
                                                                   deserialize: OWSMessageDecryptJobSerializer.sdsDeserialize))
    }
}

// MARK: - Swift Fetch

extension OWSMessageDecryptJob {
    public class func grdbFetchCursor(sql: String,
                                      arguments: [DatabaseValueConvertible]?,
                                      transaction: GRDBReadTransaction) -> OWSMessageDecryptJobCursor {
        var statementArguments: StatementArguments?
        if let arguments = arguments {
            guard let statementArgs = StatementArguments(arguments) else {
                owsFail("Could not convert arguments.")
            }
            statementArguments = statementArgs
        }
        return OWSMessageDecryptJobCursor(cursor: SDSSerialization.fetchCursor(sql: sql,
                                                             arguments: statementArguments,
                                                             transaction: transaction,
                                                                   deserialize: OWSMessageDecryptJobSerializer.sdsDeserialize))
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSMessageDecryptJobSerializer: SDSSerializer {

    private let model: OWSMessageDecryptJob
    public required init(model: OWSMessageDecryptJob) {
        self.model = model
    }

    public func serializableColumnTableMetadata() -> SDSTableMetadata {
        return OWSMessageDecryptJobSerializer.table
    }

    public func insertColumnNames() -> [String] {
        // When we insert a new row, we include the following columns:
        //
        // * "record type"
        // * "unique id"
        // * ...all columns that we set when updating.
        return [
            OWSMessageDecryptJobSerializer.recordTypeColumn.columnName,
            uniqueIdColumnName()
            ] + updateColumnNames()

    }

    public func insertColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            SDSRecordType.messageDecryptJob.rawValue
            ] + [uniqueIdColumnValue()] + updateColumnValues()
        if OWSIsDebugBuild() {
            if result.count != insertColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(insertColumnNames().count)")
            }
        }
        return result
    }

    public func updateColumnNames() -> [String] {
        return [
            OWSMessageDecryptJobSerializer.createdAtColumn,
            OWSMessageDecryptJobSerializer.envelopeDataColumn
            ].map { $0.columnName }
    }

    public func updateColumnValues() -> [DatabaseValueConvertible] {
        let result: [DatabaseValueConvertible] = [
            self.model.createdAt,
            self.model.envelopeData

        ]
        if OWSIsDebugBuild() {
            if result.count != updateColumnNames().count {
                owsFailDebug("Update mismatch: \(result.count) != \(updateColumnNames().count)")
            }
        }
        return result
    }

    public func uniqueIdColumnName() -> String {
        return OWSMessageDecryptJobSerializer.uniqueIdColumn.columnName
    }

    // TODO: uniqueId is currently an optional on our models.
    //       We should probably make the return type here String?
    public func uniqueIdColumnValue() -> DatabaseValueConvertible {
        // FIXME remove force unwrap
        return model.uniqueId!
    }
}
