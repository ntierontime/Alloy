﻿
using Alloy.Models.Media;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Alloy.Business.ContentFolders
{
    [ContentType(GUID = "e730c883-f9b7-4d5e-b309-a00070159771", DisplayName = "MDocuments", Description = "MDocuments Description", GroupName = "Restricted", AvailableInEditMode = true)]
    [AvailableContentTypes(Availability.Specific, Include = new[] { typeof(ImageFile), typeof(MDocumentExcelFile), typeof(MDocumentPdfFile), typeof(MDocumentPPTFile), typeof(MDocumentWordFile) })]
    public class MDocumentsContentFolder : ContentFolder
    {
    }
}