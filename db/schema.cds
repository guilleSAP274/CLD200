namespace riskmanagement;

using {
    managed,
    cuid,
    User,
    sap.common.CodeList
} from '@sap/cds/common';

//todo lo que tiene ENTITY es una tabla:, el namespace hace que la tabla se llamae realmente riskmanagement.Risks.
// las claves primarias son cauid y managed, 
// Es lo mismo que poner antes de title KEY ID: UUID 
// managed es un atajo para añadir: createdat, createdby, modifyas, modifyby
entity Risks : cuid, managed {
    title                   : String(100);
    owner                   : String;
    prio                    : Association to Priority;
    descr                   : String;
    miti                    : Association to Mitigations;
    impact                  : Integer;
    bp  : Association to BusinessPartners;
    virtual criticality     : Integer;
    virtual PrioCriticality : Integer;
}

//esta tabla esta asociada con miti , que es una relacion de 1 : 1 , si necesitas que sea de 1:N tienes que poner "Association to many Mitigations"
//asociacion de risk a Miti  con ON para apuntar hacia arriba
entity Mitigations : cuid, managed {
    descr    : String;
    owner    : String;
    timeline : String;
    risks    : Association to many Risks
                   on risks.miti = $self;
}

//el campo enum es un string que solo puede tener esos 3 numeradores.
entity Priority : CodeList {
    key code : String enum {
            high   = 'H';
            medium = 'M';
            low    = 'L';
        };
}

// using an external service from SAP S/4HANA Cloud
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER.csn';


entity BusinessPartners as projection on external.A_BusinessPartner {
   key BusinessPartner,
   BusinessPartnerFullName as FullName,
   LastName //si añadimos aqui los nombres que queramos que se muestren  
}