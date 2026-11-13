let
    // Create a Power BI text parameter named SourceFolder before pasting this query.
    Source = Csv.Document(
        File.Contents(SourceFolder & "\\market_context.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    TypedColumns = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"Country", type text}, {"Year", Int64.Type}, {"Market", type text},
            {"Total_Sales", type number}, {"Total_Profit", type number},
            {"Profit_Margin", type number}, {"GDP_per_capita", type number},
            {"Population", Int64.Type}, {"Internet_Usage", type number},
            {"Internet_Group", type text}
        }
    )
in
    TypedColumns
