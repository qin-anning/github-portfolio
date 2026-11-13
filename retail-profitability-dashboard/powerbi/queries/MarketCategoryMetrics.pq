let
    // Create a Power BI text parameter named SourceFolder before pasting this query.
    Source = Csv.Document(
        Binary.Decompress(
            File.Contents(SourceFolder & "\\market_category_metrics.csv.gz"),
            Compression.GZip
        ),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    TypedColumns = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"Year", Int64.Type}, {"Market", type text}, {"Category", type text},
            {"Sub_Category", type text}, {"Segment", type text}, {"Ship_Mode", type text},
            {"Internet_Group", type text}, {"Transaction_Lines", Int64.Type},
            {"Total_Sales", type number}, {"Total_Profit", type number},
            {"Total_Quantity", type number}, {"Total_Shipping_Cost", type number},
            {"Total_Shipping_Days", type number}, {"Average_Discount", type number},
            {"Loss_Lines", Int64.Type}
        }
    )
in
    TypedColumns
