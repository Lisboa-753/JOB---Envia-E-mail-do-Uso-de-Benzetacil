CREATE OR REPLACE PROCEDURE               SYS.PRC_ENVIA_EMAIL_PACIENTES_SOLICITADO_BENZATINA_PA AS
	TYPE CARACTERES IS TABLE OF VARCHAR2(50);
	CARACTERES_ISO CARACTERES;
	CARACTERES_UTF CARACTERES;   
	TEXTO CLOB;
	vPROD CLOB;
BEGIN
	FOR J IN (SELECT 
			 		 A.COD_ATENDIMENTO,
					 P.NOME_PACIENTE,
					 LISTAGG(TP.DS_TIPO_PRESCRICAO, ', ') WITHIN GROUP (ORDER BY TP.DS_TIPO_PRESCRICAO) AS MEDICAMENTO
				FROM ATENDIMENTOS A
		  INNER JOIN PRONTUARIOS P        ON A.CD_PACIENTE = P.CD_PACIENTE
		  INNER JOIN PRESCRICAO PM        ON A.COD_ATENDIMENTO = PM.COD_ATENDIMENTO
		  INNER JOIN ITEM_PRESCRICAO IPM  ON PM.CD_PRE_MED = IPM.CD_PRE_MED
		  INNER JOIN TIPO_PRESCRICAO TP   ON IPM.CD_TIPO_PRESCRICAO = TP.CD_TIPO_PRESCRICAO
		   	   WHERE 1 = 1
                 AND A.TIPO_ATENDIMENTO = 'U'  --> Urgencia/Emergencia
				 AND TRUNC(A.DATA_ATENDIMENTO) = TRUNC(SYSDATE)-1
				 AND IPM.CD_TIPO_PRESCRICAO = 22  --> Benzatina(Benzetacil)
				 AND IPM.DH_CANCELADO IS NULL
			GROUP BY
					A.COD_ATENDIMENTO,
					P.NOME_PACIENTE
			ORDER BY P.NOME_PACIENTE
			) LOOP

		vPROD := vPROD||'<tr><td>'||J.COD_ATENDIMENTO||'</td>
                             <td>'||J.NOME_PACIENTE||'</td>
                             <td>'||J.MEDICAMENTO||'</td></tr>' || chr(13);

	END LOOP;

	SELECT
		'<html>
		<head>
		<style>
		body {
			font-family: Arial;
			font-size: 12px;
			color: #444;
		}
		   pre {
			font-family: Arial;
			font-size: 12px;
			color: #444;
		}

		table {
			*border-collapse: collapse; /* IE7 and lower */
			border-spacing: 0;
			width: 100%;
		}

		.bordered {
			border: solid #ccc 1px;
			-moz-border-radius: 6px;
			-webkit-border-radius: 6px;
			border-radius: 6px;
			font-size: 12px;
		}

		.bordered tr:hover {
			background: #fbf8e9;
			-o-transition: all 0.1s ease-in-out;
			-webkit-transition: all 0.1s ease-in-out;
			-moz-transition: all 0.1s ease-in-out;
			-ms-transition: all 0.1s ease-in-out;
			transition: all 0.1s ease-in-out;
		}    

		.bordered td, .bordered th {
			border-left: 1px solid #ccc;
			border-top: 1px solid #ccc;
			padding: 4px;
			text-align: left;    
		}

		.bordered th {
			font-size: 16px;
			background-color: #dce9f9;
			background-image: -webkit-linear-gradient(top, #ebf3fc, #dce9f9);
			background-image:    -moz-linear-gradient(top, #ebf3fc, #dce9f9);
			background-image:     -ms-linear-gradient(top, #ebf3fc, #dce9f9);
			background-image:      -o-linear-gradient(top, #ebf3fc, #dce9f9);
			background-image:         linear-gradient(top, #ebf3fc, #dce9f9);
			border-top: none;
		}

		.bordered td:first-child, .bordered th:first-child {
			border-left: none;
		}

		.bordered th:first-child {
			-moz-border-radius: 6px 0 0 0;
			-webkit-border-radius: 6px 0 0 0;
			border-radius: 6px 0 0 0;

		.bordered th:last-child {
			-moz-border-radius: 0 6px 0 0;
			-webkit-border-radius: 0 6px 0 0;
			border-radius: 0 6px 0 0;
		}

		.bordered th:only-child{
			-moz-border-radius: 6px 6px 0 0;
			-webkit-border-radius: 6px 6px 0 0;
			border-radius: 6px 6px 0 0;
		}

		.bordered tr:last-child td:first-child {
			-moz-border-radius: 0 0 0 6px;
			-webkit-border-radius: 0 0 0 6px;
			border-radius: 0 0 0 6px;
		}
		}

		.bordered tr:last-child td:last-child {
			-moz-border-radius: 0 0 6px 0;
			-webkit-border-radius: 0 0 6px 0;
			border-radius: 0 0 6px 0;
		}

		.titulo{
			font-family: Arial; !importante;
			font-size: 20px;
			text-align:center;
			font-weight:bold;
		}

		.destaque{
			font-family: Arial; !importante;
			font-size: 14px;
			font-weight:normal;
		}

		.destaquenegrito
			font-family: Arial; !importante;
			font-size: 14px;
			font-weight:normal;
			font-weight:bold;
		}
		</style>'
	INTO TEXTO
	FROM DUAL;

	SELECT TEXTO||
		'</head>
		   <body>
		   <div style="font-family: Arial; font-size: 20px; text-align:center; font-weight:bold;">Hospital</div><br>
		   <div style="font-family: Arial; font-size: 16px;text-align:center; font-weight:bold;">Solicitações de Penicilina Benzatina (Benzetacil) no PA</div>
		   <br>
		   <br>
		   <div style="text-align:left; font-family: Arial; font-size: 14px;font-weight:normal;">Data Atendimentos: '||TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')||'</div>
		   <br>
		   <br>
			  <table width="100%" style="font-family: Arial; font-size: 14px;font-weight:normal;" class="bordered">
				 <tbody>
					<tr>
					   <td width="5%"><b>Atendimento</b></td>
					   <td width="50%"><b>Paciente</b></td>
					   <td width="45%"><b>Medicamento</b></td>
					</tr>'||
					vPROD
				 ||'</tbody>
			  </table><br>
		   <div align="right" class="destaquenegrito">Mensagem automática; por favor não responda.</div>
		   </body>
		</html>'
	INTO TEXTO
	FROM DUAL;			

	CARACTERES_ISO := CARACTERES('&Aacute;','&Eacute;','&Iacute;','&Oacute;','&Uacute;','&aacute;','&eacute;','&iacute;','&oacute;','&uacute;','&Acirc;','&Ecirc;','&Ocirc;',
								 '&acirc;','&ecirc;','&ocirc;','&Agrave;','&agrave;','&Uuml;','&uuml;','&Ccedil;','&ccedil;','&Atilde;','&Otilde;','&atilde;','&otilde;',
								 '&Ntilde;','&ntilde;');
	CARACTERES_UTF := CARACTERES('Á','É','Í','Ó','Ú','á','é','í','ó','ú','Â','Ê','Ô','â','ê','ô','À','à','Ü','ü','Ç','ç','Ã','Õ','ã','õ','Ñ','ñ');

	FOR ITEM IN CARACTERES_UTF.FIRST..CARACTERES_UTF.LAST LOOP
		TEXTO := REPLACE(TEXTO, CARACTERES_UTF(ITEM), CARACTERES_ISO(ITEM));
	END LOOP;

	IF vPROD IS NOT NULL THEN
		INSERT INTO UNMDRC.URC_ESCUTAMAIL 
		   ENVIAR_EMAIL(
           pTIPO_CONTEUDO   => 'text/html',
           pASSUNTO         => 'Solicitaçoes de Benzatina(Benzetacil) no PA',
           pDEPARTAMENTO    => 'Pronto Atendimento',
           pEMAIL_REMETENTE => 'sistema@empresa.com',
           pNOME_DESTINO    => 'Equipe Pronto Atendimento',
           pEMAIL_DESTINO   => 'equipe@empresa.com',
           pTITULO          => TEXTO_ASSUNTO,
           pCONTEUDO        => TEXTO
    );   
	END IF;				
END;

