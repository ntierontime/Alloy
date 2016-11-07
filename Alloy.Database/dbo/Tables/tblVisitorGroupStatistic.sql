﻿CREATE TABLE [dbo].[tblVisitorGroupStatistic] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              CONSTRAINT [tblVisitorGroupStatistic_Row] DEFAULT ((1)) NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Boolean03]          BIT              NULL,
    [Boolean04]          BIT              NULL,
    [Boolean05]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Integer02]          INT              NULL,
    [Integer03]          INT              NULL,
    [Integer04]          INT              NULL,
    [Integer05]          INT              NULL,
    [Integer06]          INT              NULL,
    [Integer07]          INT              NULL,
    [Integer08]          INT              NULL,
    [Integer09]          INT              NULL,
    [Integer10]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [Long02]             BIGINT           NULL,
    [Long03]             BIGINT           NULL,
    [Long04]             BIGINT           NULL,
    [Long05]             BIGINT           NULL,
    [DateTime01]         DATETIME         NULL,
    [DateTime02]         DATETIME         NULL,
    [DateTime03]         DATETIME         NULL,
    [DateTime04]         DATETIME         NULL,
    [DateTime05]         DATETIME         NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Guid02]             UNIQUEIDENTIFIER NULL,
    [Guid03]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [Float02]            FLOAT (53)       NULL,
    [Float03]            FLOAT (53)       NULL,
    [Float04]            FLOAT (53)       NULL,
    [Float05]            FLOAT (53)       NULL,
    [Float06]            FLOAT (53)       NULL,
    [Float07]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [String02]           NVARCHAR (MAX)   NULL,
    [String03]           NVARCHAR (MAX)   NULL,
    [String04]           NVARCHAR (MAX)   NULL,
    [String05]           NVARCHAR (MAX)   NULL,
    [String06]           NVARCHAR (MAX)   NULL,
    [String07]           NVARCHAR (MAX)   NULL,
    [String08]           NVARCHAR (MAX)   NULL,
    [String09]           NVARCHAR (MAX)   NULL,
    [String10]           NVARCHAR (MAX)   NULL,
    [Binary01]           VARBINARY (MAX)  NULL,
    [Binary02]           VARBINARY (MAX)  NULL,
    [Binary03]           VARBINARY (MAX)  NULL,
    [Binary04]           VARBINARY (MAX)  NULL,
    [Binary05]           VARBINARY (MAX)  NULL,
    [Indexed_Boolean01]  BIT              NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_Integer02]  INT              NULL,
    [Indexed_Integer03]  INT              NULL,
    [Indexed_Long01]     BIGINT           NULL,
    [Indexed_Long02]     BIGINT           NULL,
    [Indexed_DateTime01] DATETIME         NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_Float01]    FLOAT (53)       NULL,
    [Indexed_Float02]    FLOAT (53)       NULL,
    [Indexed_Float03]    FLOAT (53)       NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    [Indexed_String03]   NVARCHAR (450)   NULL,
    [Indexed_Binary01]   VARBINARY (900)  NULL,
    CONSTRAINT [PK_tblVisitorGroupStatistic] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC),
    CONSTRAINT [CH_tblVisitorGroupStatistic] CHECK ([Row]>=(1)),
    CONSTRAINT [FK_tblVisitorGroupStatistic_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_StoreName]
    ON [dbo].[tblVisitorGroupStatistic]([StoreName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Boolean01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Boolean01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Integer03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Integer03] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Long01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Long01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Long02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Long02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_DateTime01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_DateTime01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Guid01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Guid01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Float03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Float03] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String02]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_String03]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_String03] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblVisitorGroupStatistic_Indexed_Binary01]
    ON [dbo].[tblVisitorGroupStatistic]([Indexed_Binary01] ASC);

