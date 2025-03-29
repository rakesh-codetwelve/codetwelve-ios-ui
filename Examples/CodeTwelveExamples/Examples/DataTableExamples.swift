//
//  DataTableExamples.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// Transaction type enum
public enum TransactionType: String {
    case deposit = "Deposit"
    case withdrawal = "Withdrawal"
    case transfer = "Transfer"
    case payment = "Payment"
}

/// Transaction status enum
public enum TransactionStatus: String {
    case completed = "Completed"
    case pending = "Pending"
    case failed = "Failed"
    
    var color: Color {
        switch self {
        case .completed:
            return .ctSuccess
        case .pending:
            return .ctWarning
        case .failed:
            return .ctDestructive
        }
    }
}

/// A view showcasing various examples of the `CTDataTable` component.
struct DataTableExamples: View {
    // MARK: - Data Models
    
    /// Sample user model for examples
    private struct User: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let email: String
        let role: String
        let status: Status
        let joinDate: Date
        
        enum Status: String {
            case active = "Active"
            case inactive = "Inactive"
            case pending = "Pending"
            
            var color: Color {
                switch self {
                case .active:
                    return .ctSuccess
                case .inactive:
                    return .ctDestructive
                case .pending:
                    return .ctWarning
                }
            }
        }
        
        static let samples: [User] = {
            // Create a date formatter for generating join dates
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return [
                User(name: "Alice Johnson", email: "alice.j@example.com", role: "Admin", status: .active, joinDate: dateFormatter.date(from: "2023-02-15")!),
                User(name: "Bob Smith", email: "bob.smith@example.com", role: "User", status: .active, joinDate: dateFormatter.date(from: "2023-05-20")!),
                User(name: "Carol Davis", email: "carol.d@example.com", role: "Editor", status: .inactive, joinDate: dateFormatter.date(from: "2023-01-10")!),
                User(name: "Dave Wilson", email: "dave.w@example.com", role: "User", status: .pending, joinDate: dateFormatter.date(from: "2023-06-05")!),
                User(name: "Eve Brown", email: "eve.brown@example.com", role: "Admin", status: .active, joinDate: dateFormatter.date(from: "2022-11-30")!),
                User(name: "Frank Miller", email: "frank.m@example.com", role: "Editor", status: .active, joinDate: dateFormatter.date(from: "2023-03-22")!),
                User(name: "Grace Lee", email: "grace.l@example.com", role: "User", status: .inactive, joinDate: dateFormatter.date(from: "2022-09-15")!),
                User(name: "Henry Chen", email: "henry.c@example.com", role: "User", status: .active, joinDate: dateFormatter.date(from: "2023-01-28")!),
                User(name: "Irene Patel", email: "irene.p@example.com", role: "Editor", status: .pending, joinDate: dateFormatter.date(from: "2023-04-17")!),
                User(name: "Jason Kim", email: "jason.k@example.com", role: "User", status: .active, joinDate: dateFormatter.date(from: "2022-12-05")!)
            ]
        }()
    }
    
    /// Sample transaction model for examples
    private struct Transaction: Identifiable, Hashable {
        let id = UUID()
        let reference: String
        let customer: String
        let amount: Double
        let type: TransactionType
        let status: TransactionStatus
        let date: Date
        
        static let samples: [Transaction] = {
            // Create a date formatter for generating transaction dates
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Create a random reference generator
            func randomReference() -> String {
                let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let length = 8
                return "TX-" + String((0..<length).map { _ in characters.randomElement()! })
            }
            
            return [
                Transaction(reference: randomReference(), customer: "John Doe", amount: 520.50, type: .deposit, status: .completed, date: dateFormatter.date(from: "2023-06-15")!),
                Transaction(reference: randomReference(), customer: "Jane Smith", amount: 120.75, type: .payment, status: .completed, date: dateFormatter.date(from: "2023-06-14")!),
                Transaction(reference: randomReference(), customer: "Alice Johnson", amount: 980.00, type: .withdrawal, status: .failed, date: dateFormatter.date(from: "2023-06-13")!),
                Transaction(reference: randomReference(), customer: "Bob Brown", amount: 450.25, type: .transfer, status: .pending, date: dateFormatter.date(from: "2023-06-12")!),
                Transaction(reference: randomReference(), customer: "Carol Davis", amount: 1200.00, type: .deposit, status: .completed, date: dateFormatter.date(from: "2023-06-11")!),
                Transaction(reference: randomReference(), customer: "Dave Wilson", amount: 85.99, type: .payment, status: .completed, date: dateFormatter.date(from: "2023-06-10")!),
                Transaction(reference: randomReference(), customer: "Eve Brown", amount: 220.50, type: .transfer, status: .completed, date: dateFormatter.date(from: "2023-06-09")!),
                Transaction(reference: randomReference(), customer: "Frank Miller", amount: 670.25, type: .withdrawal, status: .pending, date: dateFormatter.date(from: "2023-06-08")!),
                Transaction(reference: randomReference(), customer: "Grace Lee", amount: 140.00, type: .payment, status: .failed, date: dateFormatter.date(from: "2023-06-07")!),
                Transaction(reference: randomReference(), customer: "Henry Chen", amount: 950.75, type: .deposit, status: .completed, date: dateFormatter.date(from: "2023-06-06")!),
                Transaction(reference: randomReference(), customer: "Irene Patel", amount: 345.50, type: .transfer, status: .completed, date: dateFormatter.date(from: "2023-06-05")!),
                Transaction(reference: randomReference(), customer: "Jason Kim", amount: 780.25, type: .withdrawal, status: .completed, date: dateFormatter.date(from: "2023-06-04")!)
            ]
        }()
    }
    
    // MARK: - State Properties
    
    @State private var showCode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic Usage
                Group {
                    SectionHeader(title: "Basic Usage", showCode: $showCode)
                    
                    Text("The DataTable provides advanced features for data display and manipulation.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    basicUsageSection
                    
                    if showCode {
                        CodePreview("""
                        // Define columns
                        let columns = [
                            CTDataTable.Column<User, String>(
                                id: "name",
                                title: "Name",
                                keyPath: \\.name
                            ).eraseToAnyColumn(),
                            CTDataTable.Column<User, String>(
                                id: "email",
                                title: "Email",
                                keyPath: \\.email
                            ).eraseToAnyColumn(),
                            CTDataTable.Column<User, String>(
                                id: "role",
                                title: "Role",
                                keyPath: \\.role
                            ).eraseToAnyColumn()
                        ]
                        
                        // Create the data table
                        CTDataTable(users, columns: columns)
                        """)
                    }
                }
                
                // Sorting
                Group {
                    Text("Sorting").ctHeading2()
                    
                    Text("DataTable supports sorting by clicking on column headers.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    sortingSection
                    
                    if showCode {
                        CodePreview("""
                        // Define sortable columns
                        let columns = [
                            CTDataTable.Column<User, String>(
                                id: "name",
                                title: "Name",
                                keyPath: \\.name,
                                isSortable: true
                            ).eraseToAnyColumn(),
                            CTDataTable.Column<User, String>(
                                id: "email",
                                title: "Email",
                                keyPath: \\.email,
                                isSortable: true
                            ).eraseToAnyColumn(),
                            CTDataTable.Column<User, String>(
                                id: "role",
                                title: "Role",
                                keyPath: \\.role,
                                isSortable: true
                            ).eraseToAnyColumn()
                        ]
                        
                        // Create the data table
                        CTDataTable(users, columns: columns)
                        """)
                    }
                }
                
                // Filtering and Pagination
                Group {
                    Text("Filtering and Pagination").ctHeading2()
                    
                    Text("The DataTable supports searching and pagination.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    filteringAndPaginationSection
                    
                    if showCode {
                        CodePreview("""
                        // Define columns
                        let columns = [
                            // Column definitions...
                        ]
                        
                        // Create the data table with pagination
                        CTDataTable(
                            users,
                            columns: columns,
                            paginationConfig: .init(
                                itemsPerPage: 5,
                                currentPage: 1
                            )
                        )
                        """)
                    }
                }
                
                // Custom Cell Rendering
                Group {
                    Text("Custom Cell Rendering").ctHeading2()
                    
                    Text("Columns can use custom renderers for advanced formatting.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    customCellRenderingSection
                    
                    if showCode {
                        CodePreview("""
                        // Define columns with custom renderers
                        let columns = [
                            CTDataTable.Column<User, String>(
                                id: "name",
                                title: "Name",
                                keyPath: \\.name
                            ).eraseToAnyColumn(),
                            
                            CTDataTable.Column<User, String>(
                                id: "email",
                                title: "Email",
                                keyPath: \\.email,
                                cellRenderer: { user in
                                    AnyView(
                                        Link(user.email, destination: URL(string: "mailto:\\(user.email)")!)
                                            .foregroundColor(.ctPrimary)
                                    )
                                }
                            ).eraseToAnyColumn(),
                            
                            CTDataTable.Column<User, User.Status>(
                                id: "status",
                                title: "Status",
                                keyPath: \\.status,
                                cellRenderer: { user in
                                    AnyView(
                                        HStack {
                                            Circle()
                                                .fill(user.status.color)
                                                .frame(width: 8, height: 8)
                                            Text(user.status.rawValue)
                                                .foregroundColor(user.status.color)
                                        }
                                    )
                                }
                            ).eraseToAnyColumn()
                        ]
                        
                        // Create the data table
                        CTDataTable(users, columns: columns)
                        """)
                    }
                }
                
                // Real-world Example
                Group {
                    Text("Real-world Example").ctHeading2()
                    
                    Text("A complete example with transactions data.")
                        .ctBody()
                        .foregroundColor(.ctTextSecondary)
                    
                    realWorldExample
                }
            }
            .padding()
        }
        .navigationTitle("Data Table")
    }
    
    // MARK: - Example Sections
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading) {
            CTCard {
                basicDataTable
            }
        }
        .padding(.vertical)
    }
    
    private var sortingSection: some View {
        VStack(alignment: .leading) {
            Text("Try clicking on column headers to sort by that column.")
                .ctBodySmall()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            CTCard {
                sortableDataTable
            }
        }
        .padding(.vertical)
    }
    
    private var filteringAndPaginationSection: some View {
        VStack(alignment: .leading) {
            Text("This example includes search filtering and pagination.")
                .ctBodySmall()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            CTCard {
                paginatedDataTable
            }
        }
        .padding(.vertical)
    }
    
    private var customCellRenderingSection: some View {
        VStack(alignment: .leading) {
            CTCard {
              customRenderedDataTable
                          }
                      }
                      .padding(.vertical)
                  }
                  
                  private var realWorldExample: some View {
                      VStack(alignment: .leading, spacing: CTSpacing.m) {
                          Text("Transaction Management System")
                              .ctHeading3()
                          
                          HStack {
                              Text("Recent Transactions")
                                  .ctBodyBold()
                              
                              Spacer()
                              
                              Menu {
                                  Button("Export CSV", action: {})
                                  Button("Print Report", action: {})
                                  Button("Download PDF", action: {})
                              } label: {
                                  Label("Actions", systemImage: "ellipsis.circle")
                                      .foregroundColor(.ctPrimary)
                              }
                          }
                          
                          CTCard {
                              transactionDataTable
                          }
                          
                          // Transaction summary cards
                          HStack(spacing: CTSpacing.m) {
                              // Total value
                              CTCard {
                                  VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                      Text("TOTAL VALUE")
                                          .ctCaption()
                                          .foregroundColor(.ctTextSecondary)
                                      
                                      Text("$\(formatCurrency(Transaction.samples.reduce(0) { $0 + $1.amount }))")
                                          .ctHeading2()
                                          .foregroundColor(.ctPrimary)
                                  }
                                  .padding()
                              }
                              .frame(maxWidth: .infinity)
                              
                              // Transaction count
                              CTCard {
                                  VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                      Text("TRANSACTIONS")
                                          .ctCaption()
                                          .foregroundColor(.ctTextSecondary)
                                      
                                      Text("\(Transaction.samples.count)")
                                          .ctHeading2()
                                  }
                                  .padding()
                              }
                              .frame(maxWidth: .infinity)
                              
                              // Success rate
                              CTCard {
                                  VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                      Text("SUCCESS RATE")
                                          .ctCaption()
                                          .foregroundColor(.ctTextSecondary)
                                      
                                      let successRate = Double(Transaction.samples.filter { $0.status == .completed }.count) / Double(Transaction.samples.count) * 100
                                      
                                      Text("\(Int(successRate))%")
                                          .ctHeading2()
                                          .foregroundColor(successRate > 90 ? .ctSuccess : (successRate > 70 ? .ctWarning : .ctDestructive))
                                  }
                                  .padding()
                              }
                              .frame(maxWidth: .infinity)
                          }
                      }
                      .padding(.vertical)
                  }
                  
                  // MARK: - DataTable Configurations
                  
                  /// Basic DataTable with simple columns
                  private var basicDataTable: some View {
                      CTDataTable(User.samples, columns: [
                          CTDataTable.Column<User, String>(
                              id: "name",
                              title: "Name",
                              keyPath: \.name
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, String>(
                              id: "email",
                              title: "Email",
                              keyPath: \.email
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, String>(
                              id: "role",
                              title: "Role",
                              keyPath: \.role
                          ).eraseToAnyColumn()
                      ])
                  }
                  
                  /// DataTable with sortable columns
                  private var sortableDataTable: some View {
                      CTDataTable(User.samples, columns: [
                          CTDataTable.Column<User, String>(
                              id: "name",
                              title: "Name",
                              keyPath: \.name,
                              isSortable: true
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, String>(
                              id: "email",
                              title: "Email",
                              keyPath: \.email,
                              isSortable: true
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, String>(
                              id: "role",
                              title: "Role",
                              keyPath: \.role,
                              isSortable: true
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, User.Status>(
                              id: "status",
                              title: "Status",
                              keyPath: \.status,
                              isSortable: true
                          ).eraseToAnyColumn(),
                          CTDataTable.Column<User, Date>(
                              id: "joinDate",
                              title: "Join Date",
                              keyPath: \.joinDate,
                              isSortable: true
                          ).eraseToAnyColumn()
                      ])
                  }
                  
                  /// DataTable with pagination
                  private var paginatedDataTable: some View {
                      CTDataTable(
                          User.samples,
                          columns: [
                              CTDataTable.Column<User, String>(
                                  id: "name",
                                  title: "Name",
                                  keyPath: \.name,
                                  isSortable: true
                              ).eraseToAnyColumn(),
                              CTDataTable.Column<User, String>(
                                  id: "email",
                                  title: "Email",
                                  keyPath: \.email,
                                  isSortable: true
                              ).eraseToAnyColumn(),
                              CTDataTable.Column<User, String>(
                                  id: "role",
                                  title: "Role",
                                  keyPath: \.role,
                                  isSortable: true
                              ).eraseToAnyColumn(),
                              CTDataTable.Column<User, User.Status>(
                                  id: "status",
                                  title: "Status",
                                  keyPath: \.status,
                                  isSortable: true
                              ).eraseToAnyColumn()
                          ],
                          paginationConfig: CTDataTable.PaginationConfig(
                              itemsPerPage: 5,
                              currentPage: 1
                          )
                      )
                  }
                  
                  /// DataTable with custom cell renderers
                  private var customRenderedDataTable: some View {
                      CTDataTable(User.samples, columns: [
                          CTDataTable.Column<User, String>(
                              id: "name",
                              title: "Name",
                              keyPath: \.name
                          ).eraseToAnyColumn(),
                          
                          CTDataTable.Column<User, String>(
                              id: "email",
                              title: "Email",
                              keyPath: \.email,
                              cellRenderer: { user in
                                  AnyView(
                                      Link(user.email, destination: URL(string: "mailto:\(user.email)")!)
                                          .foregroundColor(.ctPrimary)
                                  )
                              }
                          ).eraseToAnyColumn(),
                          
                          CTDataTable.Column<User, String>(
                              id: "role",
                              title: "Role",
                              keyPath: \.role,
                              cellRenderer: { user in
                                  AnyView(
                                      CTTag(user.role, style: user.role == "Admin" ? .primary :
                                                         (user.role == "Editor" ? .secondary : .default))
                                  )
                              }
                          ).eraseToAnyColumn(),
                          
                          CTDataTable.Column<User, User.Status>(
                              id: "status",
                              title: "Status",
                              keyPath: \.status,
                              cellRenderer: { user in
                                  AnyView(
                                      HStack {
                                          Circle()
                                              .fill(user.status.color)
                                              .frame(width: 8, height: 8)
                                          Text(user.status.rawValue)
                                              .foregroundColor(user.status.color)
                                      }
                                  )
                              }
                          ).eraseToAnyColumn(),
                          
                          CTDataTable.Column<User, Date>(
                              id: "joinDate",
                              title: "Join Date",
                              keyPath: \.joinDate,
                              cellRenderer: { user in
                                  AnyView(
                                      Text(formatDate(user.joinDate))
                                  )
                              }
                          ).eraseToAnyColumn()
                      ])
                  }
                  
                  /// DataTable for transactions in the real-world example
                  private var transactionDataTable: some View {
                      CTDataTable(
                          Transaction.samples,
                          columns: [
                              CTDataTable.Column<Transaction, String>(
                                  id: "reference",
                                  title: "Reference",
                                  keyPath: \.reference,
                                  isSortable: true,
                                  cellRenderer: { (transaction: Transaction) in
                                      AnyView(
                                          Text(transaction.reference)
                                              .fontWeight(.medium)
                                      )
                                  }
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, String>(
                                  id: "customer",
                                  title: "Customer",
                                  keyPath: \.customer,
                                  isSortable: true
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, Double>(
                                  id: "amount",
                                  title: "Amount",
                                  keyPath: \.amount,
                                  isSortable: true,
                                  cellRenderer: { (transaction: Transaction) in
                                      AnyView(
                                          Text("$\(formatCurrency(transaction.amount))")
                                              .foregroundColor(.ctPrimary)
                                              .frame(maxWidth: .infinity, alignment: .trailing)
                                      )
                                  }
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, TransactionType>(
                                  id: "type",
                                  title: "Type",
                                  keyPath: \.type,
                                  isSortable: true,
                                  cellRenderer: { (transaction: Transaction) in
                                      AnyView(
                                          Text(transaction.type.rawValue)
                                      )
                                  }
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, TransactionStatus>(
                                  id: "status",
                                  title: "Status",
                                  keyPath: \.status,
                                  isSortable: true,
                                  cellRenderer: { (transaction: Transaction) in
                                      AnyView(
                                          HStack {
                                              Circle()
                                                  .fill(transaction.status.color)
                                                  .frame(width: 8, height: 8)
                                              Text(transaction.status.rawValue)
                                                  .foregroundColor(transaction.status.color)
                                          }
                                      )
                                  }
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, Date>(
                                  id: "date",
                                  title: "Date",
                                  keyPath: \.date,
                                  isSortable: true,
                                  cellRenderer: { (transaction: Transaction) in
                                      AnyView(
                                          Text(formatDate(transaction.date))
                                              .foregroundColor(.ctTextSecondary)
                                      )
                                  }
                              ).eraseToAnyColumn(),
                              
                              CTDataTable.Column<Transaction, Date>(
                                  id: "actions",
                                  title: "Actions",
                                  keyPath: \.date,
                                  isSortable: false,
                                  cellRenderer: { _ in
                                      AnyView(
                                          HStack(spacing: CTSpacing.s) {
                                              Button(action: {}) {
                                                  Image(systemName: "eye")
                                                      .foregroundColor(.ctPrimary)
                                              }
                                              
                                              Button(action: {}) {
                                                  Image(systemName: "printer")
                                                      .foregroundColor(.ctSecondary)
                                              }
                                              
                                              Button(action: {}) {
                                                  Image(systemName: "ellipsis")
                                                      .foregroundColor(.ctTextSecondary)
                                              }
                                          }
                                      )
                                  }
                              ).eraseToAnyColumn()
                          ],
                          paginationConfig: CTDataTable.PaginationConfig(
                              itemsPerPage: 5,
                              currentPage: 1
                          )
                      )
                  }
                  
                  // MARK: - Helper Methods
                  
                  /// Format a Double as a currency string with 2 decimal places
                  private func formatCurrency(_ value: Double) -> String {
                      String(format: "%.2f", value)
                  }
                  
                  /// Format a Date as a short date string
                  private func formatDate(_ date: Date) -> String {
                      let formatter = DateFormatter()
                      formatter.dateStyle = .medium
                      formatter.timeStyle = .none
                      return formatter.string(from: date)
                  }
              }

              // MARK: - Previews

              struct DataTableExamples_Previews: PreviewProvider {
                  static var previews: some View {
                      NavigationView {
                          DataTableExamples()
                      }
                  }
              }
