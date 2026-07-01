import '../../../database/database.dart';
import 'finance_service.dart';

class FinanceDocumentService {
  static String agreementRef(int agreementId) =>
      'FIN-${agreementId.toString().padLeft(3, '0')}';

  static String agreementFilename(FinanceAgreement agreement) =>
      'ledger_agreement_${agreementRef(agreement.id)}.html';

  static String exportFilename(FinanceAgreement agreement) =>
      'ledger_export_${agreementRef(agreement.id)}.csv';

  static String buildAgreementHtml(
    FinanceAgreement agreement,
    List<FinancePayment> payments,
  ) {
    final ref = agreementRef(agreement.id);

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ledger Agreement - $ref</title>
  <style>
    :root {
      color-scheme: light;
      font-family: Arial, sans-serif;
      color: #111827;
      background: #f3f4f6;
    }
    body { margin: 0; padding: 32px; }
    .document {
      max-width: 860px;
      margin: 0 auto;
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 12px;
      padding: 42px;
      box-shadow: 0 18px 50px rgba(15, 23, 42, 0.10);
    }
    .header {
      display: flex;
      justify-content: space-between;
      gap: 24px;
      border-bottom: 2px solid #111827;
      padding-bottom: 18px;
      margin-bottom: 28px;
    }
    h1 { margin: 0 0 4px; font-size: 24px; }
    h2 {
      margin: 28px 0 14px;
      font-size: 13px;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #2563eb;
      border-bottom: 1px solid #bfdbfe;
      padding-bottom: 8px;
    }
    .muted { color: #6b7280; font-size: 13px; }
    .ref { text-align: right; font-weight: 700; }
    .grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 16px 28px;
    }
    .field span {
      display: block;
      color: #6b7280;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      margin-bottom: 5px;
    }
    .field strong { font-size: 15px; }
    .terms {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 12px;
      margin: 20px 0 8px;
    }
    .term {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      border-radius: 10px;
      padding: 16px;
      text-align: center;
    }
    .term span {
      display: block;
      color: #6b7280;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      margin-bottom: 8px;
    }
    .term strong { color: #1d4ed8; font-size: 20px; }
    p, li { line-height: 1.65; }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 12px;
    }
    th, td {
      border-bottom: 1px solid #e5e7eb;
      padding: 8px;
      text-align: left;
    }
    th { background: #f9fafb; font-weight: 700; }
    td.num, th.num { text-align: right; }
    .signature-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 40px;
      margin-top: 36px;
    }
    .signature-line {
      border-bottom: 1px solid #9ca3af;
      height: 42px;
      margin-bottom: 8px;
    }
    @media print {
      body { background: #fff; padding: 0; }
      .document { box-shadow: none; border: none; padding: 0; }
    }
  </style>
</head>
<body>
  <main class="document">
    <section class="header">
      <div>
        <h1>Arcanus Ledger</h1>
        <div class="muted">Personal Loan Agreement</div>
      </div>
      <div class="ref">
        <div class="muted">Agreement Ref</div>
        <div>$ref</div>
      </div>
    </section>

    <h2>Parties to this Agreement</h2>
    <div class="grid">
      <div class="field"><span>Lender</span><strong>Arcanus Ledger</strong></div>
      <div class="field"><span>Borrower</span><strong>${_html(agreement.customerName)}</strong></div>
      <div class="field" style="grid-column: 1 / -1;"><span>Borrower Address</span><strong>${_html(agreement.customerAddress ?? '-')}</strong></div>
    </div>

    <h2>Key Financial Terms</h2>
    <div class="terms">
      <div class="term"><span>Loan Amount</span><strong>${FinanceService.formatCurrency(agreement.loanAmount)}</strong></div>
      <div class="term"><span>Total Repayable</span><strong>${FinanceService.formatCurrency(agreement.totalRepayable)}</strong></div>
      <div class="term"><span>Payment Amount</span><strong>${FinanceService.formatCurrency(agreement.paymentAmount)}</strong></div>
    </div>

    <h2>Agreement Details</h2>
    <div class="grid">
      <div class="field"><span>Agreement Date</span><strong>${FinanceService.formatDate(agreement.agreementDate)}</strong></div>
      <div class="field"><span>First Payment Date</span><strong>${FinanceService.formatDate(agreement.firstPaymentDate)}</strong></div>
      <div class="field"><span>Interest Rate</span><strong>${agreement.interestRate.toStringAsFixed(2)}%</strong></div>
      <div class="field"><span>Payment Frequency</span><strong>${_html(agreement.paymentFrequency)}</strong></div>
      <div class="field"><span>Number of Payments</span><strong>${agreement.paymentCount}</strong></div>
      <div class="field"><span>Total Interest</span><strong>${FinanceService.formatCurrency(agreement.totalInterest)}</strong></div>
    </div>

    <h2>Terms and Conditions</h2>
    <p>This Personal Loan Agreement is entered into on the Agreement Date shown above between <strong>Arcanus Ledger</strong> and the Borrower named above.</p>
    <ol>
      <li>The Lender agrees to lend the Borrower the Loan Amount stated above.</li>
      <li>The Borrower agrees to repay the Total Repayable amount by making payments of the Payment Amount at the Payment Frequency stated, commencing on the First Payment Date.</li>
      <li>Interest is calculated on a reducing balance basis at the Interest Rate stated above.</li>
      <li>The Borrower may settle this agreement early at any time. The settlement figure will be the outstanding capital balance at the date of settlement with no additional interest or early repayment charges applied.</li>
      <li>Payments not received by the due date may result in the account being marked as overdue.</li>
    </ol>

    <h2>Repayment Schedule</h2>
    ${_scheduleTable(payments)}

    <h2>Signatures</h2>
    <p>By signing below, both parties confirm they have read, understood and agree to the terms of this Agreement.</p>
    <div class="signature-grid">
      <div>
        <div class="signature-line"></div>
        <strong>${_html(agreement.customerName)}</strong>
        <div class="muted">Borrower signature and date</div>
      </div>
      <div>
        <div class="signature-line"></div>
        <strong>Arcanus Ledger</strong>
        <div class="muted">Authorised signature and date</div>
      </div>
    </div>
  </main>
</body>
</html>
''';
  }

  static String buildAgreementCsv(
    FinanceAgreement agreement,
    List<FinancePayment> payments,
  ) {
    final rows = <List<String>>[
      ['Agreement Ref', agreementRef(agreement.id)],
      ['Customer', agreement.customerName],
      ['Address', agreement.customerAddress ?? ''],
      ['Agreement Date', agreement.agreementDate],
      ['First Payment Date', agreement.firstPaymentDate],
      ['Loan Amount', agreement.loanAmount.toStringAsFixed(2)],
      ['Interest Rate', agreement.interestRate.toStringAsFixed(2)],
      ['Payment Frequency', agreement.paymentFrequency],
      ['Payment Count', agreement.paymentCount.toString()],
      ['Payment Amount', agreement.paymentAmount.toStringAsFixed(2)],
      ['Total Interest', agreement.totalInterest.toStringAsFixed(2)],
      ['Total Repayable', agreement.totalRepayable.toStringAsFixed(2)],
      [],
      [
        'Payment No',
        'Due Date',
        'Opening Balance',
        'Payment Amount',
        'Interest',
        'Capital',
        'Closing Balance',
        'Status',
        'Row Type',
      ],
      ...payments.map(
        (payment) => [
          payment.paymentNo.toString(),
          payment.dueDate,
          payment.openingBalance.toStringAsFixed(2),
          payment.paymentAmount.toStringAsFixed(2),
          payment.interestAmount.toStringAsFixed(2),
          payment.capitalAmount.toStringAsFixed(2),
          payment.closingBalance.toStringAsFixed(2),
          payment.paid == 1 ? 'Paid' : 'Pending',
          payment.rowType,
        ],
      ),
    ];

    return rows.map(_csvRow).join('\n');
  }

  static String _scheduleTable(List<FinancePayment> payments) {
    final body = payments.map((payment) {
      final status = payment.paid == 1 ? 'Paid' : 'Pending';
      final paymentNo =
          payment.rowType == 'SETTLEMENT' ? 'S' : payment.paymentNo.toString();

      return '''
      <tr>
        <td>$paymentNo</td>
        <td>${payment.rowType == 'SETTLEMENT' ? 'Settlement' : FinanceService.formatDate(payment.dueDate)}</td>
        <td class="num">${FinanceService.formatCurrency(payment.openingBalance)}</td>
        <td class="num">${FinanceService.formatCurrency(payment.paymentAmount)}</td>
        <td class="num">${FinanceService.formatCurrency(payment.interestAmount)}</td>
        <td class="num">${FinanceService.formatCurrency(payment.capitalAmount)}</td>
        <td class="num">${FinanceService.formatCurrency(payment.closingBalance)}</td>
        <td>$status</td>
      </tr>''';
    }).join();

    return '''
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Due Date</th>
          <th class="num">Opening</th>
          <th class="num">Payment</th>
          <th class="num">Interest</th>
          <th class="num">Capital</th>
          <th class="num">Closing</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>$body</tbody>
    </table>''';
  }

  static String _csvRow(List<String> values) {
    return values.map((value) {
      final escaped = value.replaceAll('"', '""');
      if (escaped.contains(',') ||
          escaped.contains('"') ||
          escaped.contains('\n')) {
        return '"$escaped"';
      }
      return escaped;
    }).join(',');
  }

  static String _html(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
